import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_aliyun_slider/flutter_aliyun_slider.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aliyun_slider');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AliyunCaptcha.sdkVersion, '42');
  });
}
