package br.com.yanncabral.open_settings_plus

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** Opens settings without treating a launch as confirmation of a permission change. */
class OpenSettingsPlusPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var mContext: Context
  private lateinit var channel: MethodChannel
  private var activity: Activity? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "open_settings_plus")
    channel.setMethodCallHandler(this)
    mContext = binding.applicationContext
  }

  private fun normalizeTarget(target: String): String = when (target) {
    "android.settings.APPLICATION_NOTIFICATION_SETTINGS" -> "android.settings.APP_NOTIFICATION_SETTINGS"
    "android.settings.APPLICATION_WRITE_SETTINGS" -> "android.settings.action.MANAGE_WRITE_SETTINGS"
    "android.settings.MANAGE_EXTERNAL_SOURCES_SETTINGS" -> "android.settings.MANAGE_UNKNOWN_APP_SOURCES"
    "android.settings.VPN_SETTINGS" -> if (Build.VERSION.SDK_INT < 24) "android.net.vpn.SETTINGS" else target
    else -> target
  }

  private fun requiresPackage(target: String): Boolean = when (target) {
    "android.settings.APPLICATION_DETAILS_SETTINGS",
    "android.settings.APP_NOTIFICATION_SETTINGS",
    "android.settings.APP_NOTIFICATION_BUBBLE_SETTINGS",
    "android.settings.APP_OPEN_BY_DEFAULT_SETTINGS",
    "android.settings.action.MANAGE_WRITE_SETTINGS",
    "android.settings.IGNORE_BACKGROUND_DATA_RESTRICTIONS_SETTINGS",
    "android.settings.MANAGE_UNKNOWN_APP_SOURCES",
    "android.settings.MANAGE_OVERLAY_PERMISSION",
    "android.settings.APP_LOCALE_SETTINGS",
    "android.settings.REQUEST_SCHEDULE_EXACT_ALARM" -> true
    else -> false
  }

  private fun minimumSdk(target: String): Int = when (target) {
    "android.settings.APP_LOCALE_SETTINGS" -> 33
    "android.settings.REQUEST_SCHEDULE_EXACT_ALARM",
    "android.settings.APP_OPEN_BY_DEFAULT_SETTINGS" -> 31
    "android.settings.panel.action.WIFI",
    "android.settings.panel.action.INTERNET_CONNECTIVITY",
    "android.settings.panel.action.NFC",
    "android.settings.panel.action.VOLUME",
    "android.settings.APP_NOTIFICATION_BUBBLE_SETTINGS" -> 29
    "android.settings.MANAGE_UNKNOWN_APP_SOURCES" -> 26
    "android.settings.IGNORE_BACKGROUND_DATA_RESTRICTIONS_SETTINGS" -> 24
    "android.settings.action.MANAGE_WRITE_SETTINGS",
    "android.settings.MANAGE_OVERLAY_PERMISSION" -> 23
    else -> 1
  }

  private fun applyAppSpecificTarget(target: String, intent: Intent) {
    if (target == "android.settings.APP_NOTIFICATION_SETTINGS" ||
        target == "android.settings.APP_NOTIFICATION_BUBBLE_SETTINGS") {
      if (Build.VERSION.SDK_INT >= 26) {
        intent.putExtra("android.provider.extra.APP_PACKAGE", mContext.packageName)
      } else if (Build.VERSION.SDK_INT >= 21) {
        intent.putExtra("app_package", mContext.packageName)
        intent.putExtra("app_uid", mContext.applicationInfo.uid)
      } else {
        intent.data = Uri.fromParts("package", mContext.packageName, null)
      }
    } else {
      intent.data = Uri.fromParts("package", mContext.packageName, null)
    }
  }

  private fun startIntentSafely(intent: Intent, asAnotherTask: Boolean): String {
    val launchContext = if (asAnotherTask) mContext else activity ?: mContext
    if (asAnotherTask || launchContext !is Activity) {
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    }
    return try {
      launchContext.startActivity(intent)
      "opened"
    } catch (_: ActivityNotFoundException) {
      "unsupported"
    } catch (_: SecurityException) {
      "failed"
    } catch (_: IllegalArgumentException) {
      "failed"
    }
  }

  private fun openTarget(
    target: String,
    appSpecific: Boolean,
    asAnotherTask: Boolean,
    fallbackToAppSettings: Boolean
  ): String {
    if (target.isBlank()) return "failed"
    val normalized = normalizeTarget(target)
    val outcome = if (Build.VERSION.SDK_INT < minimumSdk(normalized)) {
      "unsupported"
    } else {
      val intent = Intent(normalized)
      if (appSpecific || requiresPackage(normalized)) applyAppSpecificTarget(normalized, intent)
      startIntentSafely(intent, asAnotherTask)
    }
    if (outcome == "opened" || !fallbackToAppSettings ||
        normalized == "android.settings.APPLICATION_DETAILS_SETTINGS") return outcome

    val fallback = openTarget(
      "android.settings.APPLICATION_DETAILS_SETTINGS", true, asAnotherTask, false
    )
    return if (fallback == "opened") "fallbackOpened" else "failed"
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "openSettings", "openSettingsDetailed", "openAndroidIntent" -> {
        val detailed = call.method == "openSettingsDetailed"
        val target = call.argument<String>(
          if (call.method == "openAndroidIntent") "action" else "settingToOpen"
        )
        if (target == null) {
          result.success(if (detailed) "failed" else false)
          return
        }
        val normalized = normalizeTarget(target)
        val appSpecific = call.argument<Boolean>("appSpecific") ?: false
        val fallback = call.argument<Boolean>("fallbackToAppSettings")
          ?: (detailed || appSpecific || requiresPackage(normalized))
        val outcome = openTarget(
          target, appSpecific, call.argument<Boolean>("asAnotherTask") ?: true, fallback
        )
        result.success(if (detailed) outcome else outcome == "opened" || outcome == "fallbackOpened")
      }
      "openAndroidPanel" -> {
        val target = when (call.argument<String>("panel")) {
          "wifi" -> "android.settings.panel.action.WIFI"
          "internetConnectivity" -> "android.settings.panel.action.INTERNET_CONNECTIVITY"
          "nfc" -> "android.settings.panel.action.NFC"
          "volume" -> "android.settings.panel.action.VOLUME"
          else -> null
        }
        result.success(if (target == null) "unsupported" else openTarget(
          target, false, call.argument<Boolean>("asAnotherTask") ?: false, false
        ))
      }
      else -> result.notImplemented()
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    activity = null
  }
}
