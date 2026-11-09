import AdSupport
import CoreTelephony
import Foundation
import SystemConfiguration
import UIKit
import WebKit

enum TbaNetworkType: String {
  case none
  case wifi
  case cellular
}

func getDistinctId() -> String {
  let defaults = UserDefaults.standard
  let key = "distinctid_native"
  if let value = defaults.string(forKey: key) {
    return value
  }
  let value = UUID().uuidString
  defaults.set(value, forKey: key)
  return value
}

func getScreenRes() -> String {
  "\(UIScreen.main.bounds.size.width) * \(UIScreen.main.bounds.size.height)"
}

func getNetworkType() -> TbaNetworkType {
  guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com") else {
    return .none
  }
  var flags: SCNetworkReachabilityFlags = []
  guard SCNetworkReachabilityGetFlags(reachability, &flags),
        flags.contains(.reachable),
        !flags.contains(.connectionRequired) else {
    return .none
  }
  return flags.contains(.isWWAN) ? .cellular : .wifi
}

func getTimeZone() -> String {
  let zone = TimeZone.current
  return "\(zone.abbreviation() ?? "Unknown") (\(zone.identifier))"
}

func getAppVersion() -> String {
  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
}

func getOSVersion() -> String { UIDevice.current.systemVersion }
func generateLogId() -> String { UUID().uuidString }
func getBundleID() -> String { Bundle.main.bundleIdentifier ?? "Unknown" }
func getDeviceModel() -> String { UIDevice.current.model }
func getSystemLanguage() -> String { Locale.preferredLanguages.first ?? "Unknown" }
func getDeviceCountry() -> String { Locale.current.regionCode ?? "Unknown" }

func getUserAgent(completion: @escaping (String) -> Void) {
  let webView = WKWebView(frame: .zero)
  webView.evaluateJavaScript("navigator.userAgent") { value, _ in
    completion(value as? String ?? "")
  }
}

func getIDFA() -> String {
  ASIdentifierManager.shared().advertisingIdentifier.uuidString
}

func getIDFV() -> String {
  UIDevice.current.identifierForVendor?.uuidString ?? ""
}

func getCarrierNetworkCode() -> String {
  let info = CTTelephonyNetworkInfo()
  if #available(iOS 12.0, *),
     let carrier = info.serviceSubscriberCellularProviders?.values.first {
    return carrier.mobileNetworkCode ?? ""
  }
  return info.subscriberCellularProvider?.mobileNetworkCode ?? ""
}

func getSystemBuildVersion() -> String {
  "build/\(UIDevice.current.systemVersion)"
}

func getBundleTimestamp(_: FileAttributeKey) -> Int64 {
  Int64(Date().timeIntervalSince1970 * 1000)
}
