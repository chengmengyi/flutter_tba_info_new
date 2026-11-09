import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_tba_info_new_method_channel.dart';

abstract class FlutterTbaInfoNewPlatform extends PlatformInterface {
  FlutterTbaInfoNewPlatform() : super(token: _token);

  static final Object _token = Object();
  static FlutterTbaInfoNewPlatform _instance = MethodChannelFlutterTbaInfoNew();

  static FlutterTbaInfoNewPlatform get instance => _instance;

  static set instance(FlutterTbaInfoNewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> getDistinctId() => throw UnimplementedError();
  Future<String> getScreenRes() => throw UnimplementedError();
  Future<String> getNetworkType() => throw UnimplementedError();
  Future<String> getZoneOffset() => throw UnimplementedError();
  Future<String> getGaid() => throw UnimplementedError();
  Future<String> getAppVersion() => throw UnimplementedError();
  Future<String> getOsVersion() => throw UnimplementedError();
  Future<String> getLogId() => throw UnimplementedError();
  Future<String> getBrand() => throw UnimplementedError();
  Future<String> getBundleId() => throw UnimplementedError();
  Future<String> getManufacturer() => throw UnimplementedError();
  Future<String> getDeviceModel() => throw UnimplementedError();
  Future<String> getAndroidId() => throw UnimplementedError();
  Future<String> getSystemLanguage() => throw UnimplementedError();
  Future<String> getOsCountry() => throw UnimplementedError();
  Future<String> getOperator() => throw UnimplementedError();
  Future<String> getDefaultUserAgent() => throw UnimplementedError();
  Future<String> getIdfa() => throw UnimplementedError();
  Future<String> getIdfv() => throw UnimplementedError();
  Future<void> jumpToEmail(String email) => throw UnimplementedError();
  Future<String> getBuild() => throw UnimplementedError();
  Future<int> getFirstInstallTime() => throw UnimplementedError();
  Future<int> getLastUpdateTime() => throw UnimplementedError();
}
