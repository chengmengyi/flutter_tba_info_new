package com.flutter.info.flutter_tba_info_new

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.os.Build
import android.provider.Settings
import android.telephony.TelephonyManager
import android.util.DisplayMetrics
import android.view.WindowManager
import com.google.android.gms.ads.identifier.AdvertisingIdClient
import java.security.MessageDigest
import java.util.Locale
import java.util.TimeZone
import java.util.UUID

internal fun getDistinctId(context: Context): String = md5(getAndroidId(context))

internal fun md5(raw: String): String = runCatching {
    MessageDigest.getInstance("MD5")
        .digest(raw.toByteArray())
        .joinToString("") { "%02x".format(it) }
}.getOrDefault(raw)

@Suppress("DEPRECATION")
internal fun getScreenRes(context: Context): String {
    val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    val displayMetrics = DisplayMetrics()
    windowManager.defaultDisplay.getMetrics(displayMetrics)
    return displayMetrics.density.toString()
}

@SuppressLint("MissingPermission")
@Suppress("DEPRECATION")
internal fun getNetworkType(context: Context): String = runCatching {
    val connectivityManager =
        context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    val activeNetworkInfo = connectivityManager.activeNetworkInfo
    when {
        activeNetworkInfo?.isConnected != true -> "no"
        activeNetworkInfo.type == ConnectivityManager.TYPE_WIFI -> "wifi"
        activeNetworkInfo.type == ConnectivityManager.TYPE_MOBILE -> "mobile"
        else -> "no"
    }
}.getOrDefault("no")

internal fun getZoneOffset(): String =
    (TimeZone.getDefault().rawOffset / 3600 / 1000).toString()

internal fun getGaid(context: Context): String = runCatching {
    AdvertisingIdClient.getAdvertisingIdInfo(context).id ?: ""
}.getOrDefault("")

@Suppress("DEPRECATION")
internal fun getAppVersion(context: Context): String = runCatching {
    context.packageManager
        .getPackageInfo(context.packageName, PackageManager.GET_META_DATA)
        .versionName.orEmpty()
}.getOrDefault("")

internal fun getOsVersion(): String = Build.VERSION.RELEASE
internal fun getLogId(): String = UUID.randomUUID().toString()
internal fun getBrand(): String = Build.BRAND
internal fun getBundleId(context: Context): String = context.packageName
internal fun getManufacturer(): String = Build.MANUFACTURER
internal fun getDeviceModel(): String = Build.MODEL

internal fun getAndroidId(context: Context): String = runCatching {
    val id = Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
    if (id == "9774d56d682e549c") "" else id.orEmpty()
}.getOrDefault("")

internal fun getSystemLanguage(): String = Locale.getDefault().let {
    "${it.language}_${it.country}"
}

internal fun getOsCountry(): String = Locale.getDefault().country

internal fun getOperator(context: Context): String = runCatching {
    val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    telephonyManager.networkOperator.orEmpty()
}.getOrDefault("")
