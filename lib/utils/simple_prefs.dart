import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SimplePrefs {
  static SimplePrefs? _instance;
  static SimplePrefs get instance => _instance ??= SimplePrefs._();

  SimplePrefs._();

  late File _file;
  Map<String, dynamic> _data = {};

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/simple_prefs.json');

    if (await _file.exists()) {
      final content = await _file.readAsString();
      _data = jsonDecode(content);
    }
  }

  Future<void> _save() async {
    await _file.writeAsString(jsonEncode(_data));
  }

  String? getString(String key) => _data[key] as String?;

  Future<void> setString(String key, String value) async {
    _data[key] = value;
    await _save();
  }

  Future<void> remove(String key) async {
    _data.remove(key);
    await _save();
  }

  Future<void> clear() async {
    _data.clear();
    await _save();
  }
}
