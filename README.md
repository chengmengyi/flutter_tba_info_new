# flutter_tba_info_new

Device, application, network, advertising identifier, and install-referrer
information for Android and iOS.

## Usage

```dart
import 'package:flutter_tba_info_new/flutter_tba_info_new.dart';

final info = FlutterTbaInfoNew.instance;
final deviceId = await info.getDistinctId();
final referrer = await info.getReferrerMap();
```

Available methods:

- `getDistinctId`, `getScreenRes`, `getNetworkType`, `getZoneOffset`
- `getGaid`, `getIdfa`, `getIdfv`, `getAndroidId`
- `getAppVersion`, `getOsVersion`, `getBuild`, `getBundleId`
- `getLogId`, `getBrand`, `getManufacturer`, `getDeviceModel`
- `getSystemLanguage`, `getOsCountry`, `getOperator`
- `getDefaultUserAgent`, `getReferrerMap`, `jumpToEmail`

Platform-specific identifiers return an empty string when requested on the
other platform. Apps that access IDFA must provide their own App Tracking
Transparency prompt and usage description when required.
