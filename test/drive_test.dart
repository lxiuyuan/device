import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drive/drive.dart';

void main() {
  const MethodChannel channel = MethodChannel('drive');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Drive.platformVersion, '42');
  });
}
