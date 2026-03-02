package br.com.yanncabral.open_settings_plus

import androidx.annotation.NonNull
import android.content.Context
import android.content.Intent
import android.net.Uri

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** OpenSettingsPlusPlugin */
class OpenSettingsPlusPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var mContext : Context
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "open_settings_plus")
    channel.setMethodCallHandler(this)
    mContext = flutterPluginBinding.getApplicationContext();
  }

  private fun normalizeTarget(target: String): String {
    return when (target) {
      "android.settings.APPLICATION_NOTIFICATION_SETTINGS" -> {
        "android.settings.APP_NOTIFICATION_SETTINGS"
      }
      else -> target
    }
  }

  private fun openSettings(target: String): Boolean {
    val normalizedTarget = normalizeTarget(target)
    val intent = Intent(normalizedTarget)
    if (intent.action == null) return false
    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
    return startIntentSafely(intent)
  }

  private fun openSettingsWithPackage(target: String): Boolean {
    val normalizedTarget = normalizeTarget(target)
    val intent = Intent(normalizedTarget)
    if (intent.action == null) return false

    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
    applyAppSpecificTarget(normalizedTarget, intent)

    if (startIntentSafely(intent)) {
      return true
    }

    if (normalizedTarget != "android.settings.APPLICATION_DETAILS_SETTINGS") {
      return openSettingsWithPackage("android.settings.APPLICATION_DETAILS_SETTINGS")
    }

    return false
  }

  private fun applyAppSpecificTarget(target: String, intent: Intent) {
    if (target != "android.settings.APP_NOTIFICATION_SETTINGS") {
      intent.data = Uri.fromParts("package", mContext.packageName, null)
      return
    }

    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
      intent.putExtra("android.provider.extra.APP_PACKAGE", mContext.packageName)
    } else if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
      intent.putExtra("app_package", mContext.packageName)
      intent.putExtra("app_uid", mContext.applicationInfo.uid)
    } else {
      intent.data = Uri.fromParts("package", mContext.packageName, null)
    }
  }

  private fun startIntentSafely(intent: Intent): Boolean {
    return try {
      mContext.startActivity(intent)
      true
    } catch (_: Exception) {
      false
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "openSettings" -> {
        val settingToOpen = call.argument<String>("settingToOpen")
        if (settingToOpen == null) {
          result.success(false)
          return
        }

        val success = when (settingToOpen) {
          "android.settings.APPLICATION_DETAILS_SETTINGS",
          "android.settings.APPLICATION_NOTIFICATION_SETTINGS",
          "android.settings.APP_NOTIFICATION_SETTINGS" -> {
            openSettingsWithPackage(settingToOpen)
          }
          else -> {
            openSettings(settingToOpen)
          }
        }
        result.success(success)
      }
      "openAndroidIntent" -> {
        val action = call.argument<String>("action")
        val appSpecific = call.argument<Boolean>("appSpecific") ?: false

        if (action == null) {
          result.success(false)
          return
        }

        val success = if (appSpecific) {
          openSettingsWithPackage(action)
        } else {
          openSettings(action)
        }

        result.success(success)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
