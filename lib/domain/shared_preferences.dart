abstract class ISharedPreferencesService {
  bool getBool(String key, {bool defaultValue = false});
  Future<void> setBool(String key, bool value);

  int getInt(String key, {int defaultValue = 0});
  Future<void> setInt(String key, int value);

  String getString(String key, {String defaultValue = ''});
  Future<void> setString(String key, String value);
}
