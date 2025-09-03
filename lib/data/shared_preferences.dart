import 'package:shared_preferences/shared_preferences.dart';

import '../domain/shared_preferences.dart';

class SharedPreferencesService implements ISharedPreferencesService {
  final SharedPreferences _sharedPreferences;
  SharedPreferencesService._(this._sharedPreferences);
  static Future<SharedPreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesService._(prefs);
  }

  @override
  bool getBool(String key, {bool defaultValue = false}) => _sharedPreferences.getBool(key) ?? defaultValue;

  @override
  Future<bool> setBool(String key, bool value) => _sharedPreferences.setBool(key, value);

  @override
  int getInt(String key, {int defaultValue = 0}) => _sharedPreferences.getInt(key) ?? defaultValue;

  @override
  Future<bool> setInt(String key, int value) => _sharedPreferences.setInt(key, value);

  @override
  String getString(String key, {String defaultValue = ''}) => _sharedPreferences.getString(key) ?? defaultValue;

  @override
  Future<bool> setString(String key, String value) => _sharedPreferences.setString(key, value);
}
