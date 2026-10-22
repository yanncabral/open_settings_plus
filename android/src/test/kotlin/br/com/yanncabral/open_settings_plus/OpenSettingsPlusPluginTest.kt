package br.com.yanncabral.open_settings_plus

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Robolectric
import org.robolectric.Shadows.shadowOf
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [33], manifest = Config.NONE)
class OpenSettingsPlusPluginTest {
  private class LaunchContext(base: Context, private val failures: List<RuntimeException?>) : ContextWrapper(base) {
    val intents = mutableListOf<Intent>()
    override fun startActivity(intent: Intent) {
      intents.add(intent)
      failures.getOrNull(intents.size - 1)?.let { throw it }
    }
  }

  private class CapturedResult : MethodChannel.Result {
    var calls = 0
    var value: Any? = null
    override fun success(result: Any?) { calls++; value = result }
    override fun error(code: String, message: String?, details: Any?) {
      fail("Unexpected platform error: $code $message")
    }
    override fun notImplemented() { fail("Unexpected unimplemented method") }
  }

  private fun run(
    target: String,
    method: String = "openSettingsDetailed",
    options: Map<String, Any> = emptyMap(),
    failures: List<RuntimeException?> = emptyList(),
    activity: Activity? = null
  ): Pair<Any?, LaunchContext> {
    val context = LaunchContext(RuntimeEnvironment.getApplication(), failures)
    val plugin = OpenSettingsPlusPlugin()
    // Keep production API unchanged while testing actual Android Intent behavior.
    OpenSettingsPlusPlugin::class.java.getDeclaredField("mContext").apply {
      isAccessible = true
      set(plugin, context)
    }
    OpenSettingsPlusPlugin::class.java.getDeclaredField("activity").apply {
      isAccessible = true
      set(plugin, activity)
    }
    val targetKey = when (method) {
      "openAndroidPanel" -> "panel"
      "openAndroidIntent" -> "action"
      else -> "settingToOpen"
    }
    val result = CapturedResult()
    plugin.onMethodCall(MethodCall(method, options + (targetKey to target)), result)
    assertEquals("Every call completes once", 1, result.calls)
    return result.value to context
  }

  @Test fun notificationAliasIncludesAppPackageAndNewTask() {
    val (result, context) = run("android.settings.APPLICATION_NOTIFICATION_SETTINGS")
    assertEquals("opened", result)
    val intent = context.intents.single()
    assertEquals("android.settings.APP_NOTIFICATION_SETTINGS", intent.action)
    assertEquals(context.packageName, intent.getStringExtra("android.provider.extra.APP_PACKAGE"))
    assertTrue(intent.flags and Intent.FLAG_ACTIVITY_NEW_TASK != 0)
  }

  @Test fun unavailableDestinationReportsFallbackAndScopesPackage() {
    val (result, context) = run("vendor.settings.MISSING", failures = listOf(ActivityNotFoundException()))
    assertEquals("fallbackOpened", result)
    assertEquals(2, context.intents.size)
    assertEquals("android.settings.APPLICATION_DETAILS_SETTINGS", context.intents.last().action)
    assertEquals("package:${context.packageName}", context.intents.last().data.toString())
  }

  @Test fun disabledFallbackPreservesUnsupported() {
    val (result, context) = run("vendor.settings.MISSING",
      options = mapOf("fallbackToAppSettings" to false), failures = listOf(ActivityNotFoundException()))
    assertEquals("unsupported", result)
    assertEquals(1, context.intents.size)
  }

  @Test fun failedFallbackReportsFailed() {
    val (result, context) = run("vendor.settings.MISSING",
      failures = listOf(ActivityNotFoundException(), SecurityException()))
    assertEquals("failed", result)
    assertEquals(2, context.intents.size)
  }

  @Test fun appSettingsFailureDoesNotRetryItself() {
    val (result, context) = run("android.settings.APPLICATION_DETAILS_SETTINGS",
      failures = listOf(SecurityException()))
    assertEquals("failed", result)
    assertEquals(1, context.intents.size)
  }

  @Test @Config(sdk = [28]) fun panelsAreUnsupportedBelowAndroid10WithoutFallback() {
    val (result, context) = run("wifi", method = "openAndroidPanel")
    assertEquals("unsupported", result)
    assertTrue(context.intents.isEmpty())
  }

  @Test @Config(sdk = [32]) fun appLanguageVersionGateCanFallback() {
    val (result, context) = run("android.settings.APP_LOCALE_SETTINGS")
    assertEquals("fallbackOpened", result)
    assertEquals("android.settings.APPLICATION_DETAILS_SETTINGS", context.intents.single().action)
  }

  @Test fun panelsUsePanelIntentWithoutAppPackage() {
    val (result, context) = run("internetConnectivity", method = "openAndroidPanel")
    assertEquals("opened", result)
    assertEquals("android.settings.panel.action.INTERNET_CONNECTIVITY", context.intents.single().action)
    assertNull(context.intents.single().data)
  }

  @Test fun sameTaskUsesAttachedActivityWithoutNewTaskFlag() {
    val controller = Robolectric.buildActivity(Activity::class.java).setup()
    try {
      val activity = controller.get()
      val (result, context) = run("android.settings.WIFI_SETTINGS",
        options = mapOf("asAnotherTask" to false), activity = activity)
      assertEquals("opened", result)
      assertTrue("Application context must not launch when an Activity is attached", context.intents.isEmpty())
      val intent = requireNotNull(shadowOf(activity).nextStartedActivity) {
        "The attached Activity must launch the requested destination"
      }
      assertEquals("android.settings.WIFI_SETTINGS", intent.action)
      assertEquals(0, intent.flags and Intent.FLAG_ACTIVITY_NEW_TASK)
    } finally {
      controller.pause().stop().destroy()
    }
  }

  @Test fun sameTaskWithoutActivityUsesApplicationContextAndNewTaskFlag() {
    val (result, context) = run("android.settings.WIFI_SETTINGS",
      options = mapOf("asAnotherTask" to false))
    assertEquals("opened", result)
    val intent = context.intents.single()
    assertEquals("android.settings.WIFI_SETTINGS", intent.action)
    assertTrue(intent.flags and Intent.FLAG_ACTIVITY_NEW_TASK != 0)
  }

  @Test @Config(sdk = [23]) fun vpnUsesLegacyActionBeforeAndroid7() {
    val (result, context) = run("android.settings.VPN_SETTINGS")
    assertEquals("opened", result)
    assertEquals("android.net.vpn.SETTINGS", context.intents.single().action)
  }

  @Test fun legacyIntentPreservesBooleanFallbackSuccess() {
    val (result, context) = run("android.settings.APP_NOTIFICATION_SETTINGS", method = "openAndroidIntent",
      failures = listOf(ActivityNotFoundException()))
    assertEquals(true, result)
    assertEquals(2, context.intents.size)
  }
}
