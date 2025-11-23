import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// 获取 APP 基础信息（版本号 + build + deviceId）
Future<Map<String, String>> getAppBaseInfo() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;

  return {
    'appVersion': packageInfo.version,        // e.g. "1.0.0"
    'buildNumber': packageInfo.buildNumber,   // e.g. "1"
    'deviceId': androidInfo.id,               // ANDROID_ID
  };
}

/// 获取app版本信息
Future<Map<String, String>> getAppVersionHeaders() async {
  final info = await PackageInfo.fromPlatform();
  return {
    'app-version': info.version,       // 1.0.0
    'build-number': info.buildNumber,  // 1
  };
}

Future<String?> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  return androidInfo.id; // 安卓唯一设备号（Android ID）
}
