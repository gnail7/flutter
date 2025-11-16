import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
