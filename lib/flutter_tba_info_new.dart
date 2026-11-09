import 'dart:io';

import 'package:flutter/services.dart';
import 'package:play_install_referrer/play_install_referrer.dart';

import 'flutter_tba_info_new_platform_interface.dart';

class FlutterTbaInfoNew {
  static final FlutterTbaInfoNew _instance = FlutterTbaInfoNew();

  static FlutterTbaInfoNew get instance => _instance;

  Future<String> getDistinctId() =>
      FlutterTbaInfoNewPlatform.instance.getDistinctId();
  Future<String> getScreenRes() =>
      FlutterTbaInfoNewPlatform.instance.getScreenRes();
  Future<String> getNetworkType() =>
      FlutterTbaInfoNewPlatform.instance.getNetworkType();
  Future<String> getZoneOffset() =>
      FlutterTbaInfoNewPlatform.instance.getZoneOffset();
  Future<String> getGaid() => FlutterTbaInfoNewPlatform.instance.getGaid();
  Future<String> getAppVersion() =>
      FlutterTbaInfoNewPlatform.instance.getAppVersion();
  Future<String> getOsVersion() =>
      FlutterTbaInfoNewPlatform.instance.getOsVersion();
  Future<String> getLogId() => FlutterTbaInfoNewPlatform.instance.getLogId();
  Future<String> getBrand() => FlutterTbaInfoNewPlatform.instance.getBrand();
  Future<String> getBundleId() =>
      FlutterTbaInfoNewPlatform.instance.getBundleId();
  Future<String> getManufacturer() =>
      FlutterTbaInfoNewPlatform.instance.getManufacturer();
  Future<String> getDeviceModel() =>
      FlutterTbaInfoNewPlatform.instance.getDeviceModel();
  Future<String> getAndroidId() =>
      FlutterTbaInfoNewPlatform.instance.getAndroidId();
  Future<String> getSystemLanguage() =>
      FlutterTbaInfoNewPlatform.instance.getSystemLanguage();
  Future<String> getOsCountry() =>
      FlutterTbaInfoNewPlatform.instance.getOsCountry();
  Future<String> getOperator() =>
      FlutterTbaInfoNewPlatform.instance.getOperator();
  Future<String> getDefaultUserAgent() =>
      FlutterTbaInfoNewPlatform.instance.getDefaultUserAgent();
  Future<String> getIdfa() => FlutterTbaInfoNewPlatform.instance.getIdfa();
  Future<String> getIdfv() => FlutterTbaInfoNewPlatform.instance.getIdfv();
  Future<void> jumpToEmail(String email) =>
      FlutterTbaInfoNewPlatform.instance.jumpToEmail(email);
  Future<String> getBuild() => FlutterTbaInfoNewPlatform.instance.getBuild();

  Future<Map<String, dynamic>> getReferrerMap() async {
    final build = await getBuild();
    final userAgent = await getDefaultUserAgent();

    if (Platform.isIOS) {
      final nowTime = DateTime.now().millisecondsSinceEpoch;
      return <String, dynamic>{
        'build': build,
        'referrer_click_timestamp_seconds': nowTime,
        'install_begin_timestamp_seconds': nowTime,
        'google_play_instant': false,
        'user_agent': userAgent,
        'install_version': '',
        'last_update_seconds': nowTime,
        'install_first_seconds': nowTime,
        'referrer_url': '',
        'install_begin_timestamp_server_seconds': nowTime,
        'referrer_click_timestamp_server_seconds': nowTime,
      };
    }

    final firstInstallTime = await FlutterTbaInfoNewPlatform.instance
        .getFirstInstallTime();
    final lastUpdateTime = await FlutterTbaInfoNewPlatform.instance
        .getLastUpdateTime();

    try {
      final referrerDetails = await PlayInstallReferrer.installReferrer;
      return <String, dynamic>{
        'build': build,
        'referrer_click_timestamp_seconds':
            referrerDetails.referrerClickTimestampSeconds,
        'install_begin_timestamp_seconds':
            referrerDetails.installBeginTimestampSeconds,
        'google_play_instant': referrerDetails.googlePlayInstantParam,
        'user_agent': userAgent,
        'install_version': referrerDetails.installVersion ?? '',
        'last_update_seconds': lastUpdateTime,
        'install_first_seconds': firstInstallTime,
        'referrer_url': referrerDetails.installReferrer ?? '',
        'install_begin_timestamp_server_seconds':
            referrerDetails.installBeginTimestampServerSeconds,
        'referrer_click_timestamp_server_seconds':
            referrerDetails.referrerClickTimestampServerSeconds,
      };
    } catch(e) {
      return <String, dynamic>{
        'build': build,
        'referrer_click_timestamp_seconds': 0,
        'install_begin_timestamp_seconds': 0,
        'google_play_instant': false,
        'user_agent': userAgent,
        'install_version': '',
        'last_update_seconds': lastUpdateTime,
        'install_first_seconds': firstInstallTime,
        'referrer_url': '',
        'install_begin_timestamp_server_seconds': 0,
        'referrer_click_timestamp_server_seconds': 0,
      };
    }
  }
}
