package com.flutter.info.flutter_tba_info_new

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.webkit.WebSettings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class FlutterTbaInfoNewPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var applicationContext: Context
    private lateinit var channel: MethodChannel
    private val backgroundExecutor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "flutter_tba_info_new")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDistinctId" -> result.success(getDistinctId(applicationContext))
            "getScreenRes" -> result.success(getScreenRes(applicationContext))
            "getNetworkType" -> result.success(getNetworkType(applicationContext))
            "getZoneOffset" -> result.success(getZoneOffset())
            "getGaid" -> backgroundExecutor.execute {
                val gaid = getGaid(applicationContext)
                mainHandler.post { result.success(gaid) }
            }
            "getAppVersion" -> result.success(getAppVersion(applicationContext))
            "getOsVersion" -> result.success(getOsVersion())
            "getLogId" -> result.success(getLogId())
            "getBrand" -> result.success(getBrand())
            "getBundleId" -> result.success(getBundleId(applicationContext))
            "getManufacturer" -> result.success(getManufacturer())
            "getDeviceModel" -> result.success(getDeviceModel())
            "getAndroidId" -> result.success(getAndroidId(applicationContext))
            "getSystemLanguage" -> result.success(getSystemLanguage())
            "getOsCountry" -> result.success(getOsCountry())
            "getOperator" -> result.success(getOperator(applicationContext))
            "getDefaultUserAgent" -> result.success(
                runCatching { WebSettings.getDefaultUserAgent(applicationContext) }.getOrDefault("")
            )
            "jumpToEmail" -> jumpToEmail(call, result)
            "getBuild" -> result.success("build/${Build.VERSION.RELEASE}")
            "getFirstInstallTime" -> result.success(getPackageTime(firstInstall = true))
            "getLastUpdateTime" -> result.success(getPackageTime(firstInstall = false))
            else -> result.notImplemented()
        }
    }

    private fun jumpToEmail(call: MethodCall, result: MethodChannel.Result) {
        val address = call.argument<String>("address").orEmpty()
        val launched = runCatching {
            val intent = Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:$address"))
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            applicationContext.startActivity(intent)
            true
        }.getOrDefault(false)
        result.success(launched)
    }

    @Suppress("DEPRECATION")
    private fun getPackageTime(firstInstall: Boolean): Long = runCatching {
        val packageInfo = applicationContext.packageManager.getPackageInfo(
            applicationContext.packageName,
            0,
        )
        if (firstInstall) packageInfo.firstInstallTime else packageInfo.lastUpdateTime
    }.getOrDefault(System.currentTimeMillis())

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        backgroundExecutor.shutdown()
    }
}
