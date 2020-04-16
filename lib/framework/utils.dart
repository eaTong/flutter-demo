import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutterdemo/entities/device_info.dart';

String getPlatform() {
  if (Platform.isAndroid) {
    return 'android';
  }
  if (Platform.isIOS) {
    return 'iOS';
  }
  if (Platform.isFuchsia) {
    return 'fuchsia';
  }
  if (Platform.isWindows) {
    return 'windows';
  }
  if (Platform.isMacOS) {
    return 'macOS';
  }
  if (Platform.isLinux) {
    return 'linux';
  }
  return 'unknown';
}

Future<TotalDeviceInfo> getDeviceInfo() async {
  String deviceId;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.androidId;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    deviceId = iosDeviceInfo.identifierForVendor;
  }
  return TotalDeviceInfo(deviceId, getPlatform());
}
