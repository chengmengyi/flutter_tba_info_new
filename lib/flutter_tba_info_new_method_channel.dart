import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_tba_info_new_platform_interface.dart';

class MethodChannelFlutterTbaInfoNew extends FlutterTbaInfoNewPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_tba_info_new');

  Future<String> _string(String method) async =>
      await methodChannel.invokeMethod<String>(method) ?? '';

  @override
  Future<String> getDistinctId() => _string('getDistinctId');
  @override
  Future<String> getScreenRes() => _string('getScreenRes');
  @override
  Future<String> getNetworkType() => _string('getNetworkType');
  @override
  Future<String> getZoneOffset() => _string('getZoneOffset');
  @override
  Future<String> getGaid() => _string('getGaid');
  @override
  Future<String> getAppVersion() => _string('getAppVersion');
  @override
  Future<String> getOsVersion() => _string('getOsVersion');
  @override
  Future<String> getLogId() => _string('getLogId');
  @override
  Future<String> getBrand() => _string('getBrand');
  @override
  Future<String> getBundleId() => _string('getBundleId');
  @override
  Future<String> getManufacturer() => _string('getManufacturer');
  @override
  Future<String> getDeviceModel() => _string('getDeviceModel');
  @override
  Future<String> getAndroidId() =>
      Platform.isIOS ? Future<String>.value('') : _string('getAndroidId');
  @override
  Future<String> getSystemLanguage() => _string('getSystemLanguage');
  @override
  Future<String> getOsCountry() => _string('getOsCountry');
  @override
  Future<String> getOperator() => _string('getOperator');
  @override
  Future<String> getDefaultUserAgent() => _string('getDefaultUserAgent');
  @override
  Future<String> getIdfa() =>
      Platform.isAndroid ? Future<String>.value('') : _string('getIdfa');
  @override
  Future<String> getIdfv() =>
      Platform.isAndroid ? Future<String>.value('') : _string('getIdfv');
  @override
  Future<void> jumpToEmail(String email) => methodChannel.invokeMethod<void>(
    'jumpToEmail',
    <String, String>{'address': email},
  );
  @override
  Future<String> getBuild() => _string('getBuild');
  @override
  Future<int> getFirstInstallTime() async =>
      await methodChannel.invokeMethod<int>('getFirstInstallTime') ?? 0;
  @override
  Future<int> getLastUpdateTime() async =>
      await methodChannel.invokeMethod<int>('getLastUpdateTime') ?? 0;
}
