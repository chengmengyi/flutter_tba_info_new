import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tba_info_new/flutter_tba_info_new.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter_tba_info_new');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('risk environment APIs map to the expected native methods', () async {
    const values = <String, bool>{
      'is_emulator': true,
      'is_developer': true,
      'is_adb': false,
      'has_sim': true,
      'tes_lab': false,
    };
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async => values[call.method]);

    final plugin = FlutterTbaInfoNew.instance;
    expect(await plugin.isEmulator(), isTrue);
    expect(await plugin.isDeveloper(), isTrue);
    expect(await plugin.isAdb(), isFalse);
    expect(await plugin.hasSim(), isTrue);
    expect(await plugin.isFirebaseTestLab(), isFalse);

    expect(await plugin.is_emulator(), isTrue);
    expect(await plugin.is_developer(), isTrue);
    expect(await plugin.is_adb(), isFalse);
    expect(await plugin.has_sim(), isTrue);
    expect(await plugin.tes_lab(), isFalse);
  });
}
