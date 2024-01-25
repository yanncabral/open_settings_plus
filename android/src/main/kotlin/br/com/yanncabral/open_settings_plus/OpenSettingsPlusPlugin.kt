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

  private fun openSettings(target: String) {
    val intent = Intent(target)
    if (intent.action != null) {
      intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
      mContext.startActivity(intent)
    }
  }

  private fun openSettingsWithPackage(target: String) {
    val intent = Intent(target)
    if (intent.action != null) {
      intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
      intent.data = Uri.fromParts("package", mContext.packageName, null)
      mContext.startActivity(intent)
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "openSettings") {
      val settingToOpen = call.argument<String>("settingToOpen")
      if (settingToOpen != null) {
        when (settingToOpen) {
          "android.settings.APPLICATION_DETAILS_SETTINGS" -> openSettingsWithPackage(settingToOpen)
          else -> openSettings(settingToOpen)
        }
        result.success(true)
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
