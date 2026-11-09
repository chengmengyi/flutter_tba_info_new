import Flutter
import UIKit

public class FlutterTbaInfoNewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_tba_info_new",
      binaryMessenger: registrar.messenger()
    )
    let instance = FlutterTbaInfoNewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getDistinctId":
      result(getDistinctId())
    case "getScreenRes":
      result(getScreenRes())
    case "getNetworkType":
      result(getNetworkType().rawValue)
    case "getZoneOffset":
      result(getTimeZone())
    case "getGaid":
      result(getCarrierNetworkCode())
    case "getAppVersion":
      result(getAppVersion())
    case "getOsVersion":
      result(getOSVersion())
    case "getLogId":
      result(generateLogId())
    case "getBrand", "getManufacturer":
      result("Apple")
    case "getBundleId":
      result(getBundleID())
    case "getDeviceModel":
      result(getDeviceModel())
    case "getAndroidId":
      result("")
    case "getSystemLanguage":
      result(getSystemLanguage())
    case "getOsCountry":
      result(getDeviceCountry())
    case "getOperator":
      result("")
    case "getDefaultUserAgent":
      getUserAgent { result($0) }
    case "getIdfa":
      result(getIDFA())
    case "getIdfv":
      result(getIDFV())
    case "jumpToEmail":
      openEmail(call)
      result(nil)
    case "getBuild":
      result(getSystemBuildVersion())
    case "getFirstInstallTime":
      result(getBundleTimestamp(.creationDate))
    case "getLastUpdateTime":
      result(getBundleTimestamp(.modificationDate))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func openEmail(_ call: FlutterMethodCall) {
    guard let arguments = call.arguments as? [String: Any],
          let address = arguments["address"] as? String,
          let encoded = address.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
          let url = URL(string: "mailto:\(encoded)") else {
      return
    }
    UIApplication.shared.open(url)
  }
}
