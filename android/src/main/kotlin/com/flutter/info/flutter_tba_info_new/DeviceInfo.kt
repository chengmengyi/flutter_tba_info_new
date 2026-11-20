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
import java.io.File
import java.io.FileInputStream
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

internal fun isEmulator(): Boolean = isEmulatorByBuild() || isEmulatorByFiles()

private fun isEmulatorByBuild(): Boolean {
    val model = Build.MODEL.orEmpty()
    val product = Build.PRODUCT.orEmpty()
    val hardware = Build.HARDWARE.orEmpty()
    val device = Build.DEVICE.orEmpty()
    val brand = Build.BRAND.orEmpty()
    val board = Build.BOARD.orEmpty()
    val manufacturer = Build.MANUFACTURER.orEmpty()
    val bootloader = Build.BOOTLOADER.orEmpty()
    val host = Build.HOST.orEmpty()

    val immediateMatch =
        model.contains("sdk_gphone") ||
            model.contains("google_sdk") ||
            model.contains("droid4x", ignoreCase = true) ||
            model.contains("Emulator") ||
            model.contains("Android SDK built for x86") ||
            model.startsWith("iToolsAVM") ||
            manufacturer.contains("Genymotion") ||
            manufacturer.startsWith("iToolsAVM") ||
            hardware == "goldfish" ||
            hardware == "vbox86" ||
            hardware.contains("nox", ignoreCase = true) ||
            product == "sdk" ||
            product.startsWith("google_sdk") ||
            product == "sdk_x86" ||
            product == "vbox86p" ||
            product.contains("nox", ignoreCase = true) ||
            brand.startsWith("generic") ||
            device.startsWith("iToolsAVM") ||
            board.contains("nox", ignoreCase = true) ||
            bootloader.contains("nox", ignoreCase = true) ||
            host.contains("Droid4x-BuildStation")
    if (immediateMatch) return true

    var riskScore = 0
    if (product in setOf(
            "sdk_x86_64",
            "sdk_google_phone_x86",
            "sdk_google_phone_x86_64",
            "sdk_google_phone_arm64",
            "vbox86p",
        )
    ) riskScore++
    if (manufacturer == "unknown") riskScore++
    if (brand in setOf("generic", "generic_arm64", "generic_x86", "generic_x86_64") ||
        brand.equals("android", ignoreCase = true)
    ) riskScore++
    if (device in setOf("generic", "generic_arm64", "generic_x86", "generic_x86_64", "vbox86p")) {
        riskScore++
    }
    if (model in setOf(
            "sdk",
            "Android SDK built for arm64",
            "Android SDK built for armv7",
            "Android SDK built for x86",
            "Android SDK built for x86_64",
        )
    ) riskScore++
    if (hardware == "ranchu") riskScore++
    if (brand.startsWith("generic") && device.startsWith("generic")) riskScore++
    return riskScore >= 2
}

private fun isEmulatorByFiles(): Boolean {
    val emulatorFiles = listOf(
        "/dev/socket/genyd",
        "/dev/socket/baseband_genyd",
        "/fstab.andy",
        "/ueventd.andy.rc",
        "/fstab.nox",
        "/init.nox.rc",
        "/ueventd.nox.rc",
        "/dev/socket/qemud",
        "/dev/qemu_pipe",
        "/ueventd.android_x86.rc",
        "/x86.prop",
        "/ueventd.ttVM_x86.rc",
        "/init.ttVM_x86.rc",
        "/fstab.ttVM_x86",
        "/fstab.vbox86",
        "/init.vbox86.rc",
        "/ueventd.vbox86.rc",
    )
    if (emulatorFiles.any { File(it).exists() }) return true

    return listOf("/proc/tty/drivers", "/proc/cpuinfo").any { path ->
        runCatching {
            val file = File(path)
            if (!file.exists() || !file.canRead()) return@runCatching false
            val buffer = ByteArray(1024)
            val length = FileInputStream(file).use { it.read(buffer) }
            length > 0 && String(buffer, 0, length).contains("goldfish", ignoreCase = true)
        }.getOrDefault(false)
    }
}

internal fun isDeveloperMode(context: Context): Boolean = runCatching {
    Settings.Global.getInt(
        context.contentResolver,
        Settings.Global.DEVELOPMENT_SETTINGS_ENABLED,
        0,
    ) != 0
}.getOrDefault(false)

internal fun isAdbEnabled(context: Context): Boolean = runCatching {
    Settings.Global.getInt(context.contentResolver, Settings.Global.ADB_ENABLED, 0) != 0
}.getOrDefault(false)

internal fun hasSim(context: Context): Boolean = runCatching {
    val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    val state = telephonyManager.simState
    state != TelephonyManager.SIM_STATE_ABSENT && state != TelephonyManager.SIM_STATE_UNKNOWN
}.getOrDefault(true)

internal fun isFirebaseTestLab(context: Context): Boolean = runCatching {
    val systemValue = Settings.System.getString(context.contentResolver, "firebase.test.lab")
    val secureValue = Settings.Secure.getString(context.contentResolver, "firebase.test.lab")
    systemValue.equals("true", ignoreCase = true) ||
        secureValue.equals("true", ignoreCase = true)
}.getOrDefault(false)
