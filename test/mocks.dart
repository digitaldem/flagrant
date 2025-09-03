import 'package:flagrant/domain/shared_preferences.dart';
import 'package:flagrant/domain/wakelock.dart';

class MockSharedPreferencesService implements ISharedPreferencesService {
  final Map<String, Object?> _store = {};

  @override
  bool getBool(String key, {bool defaultValue = false}) => (_store[key] as bool?) ?? defaultValue;

  @override
  Future<bool> setBool(String key, bool value) async {
    _store[key] = value;
    return true;
  }

  @override
  int getInt(String key, {int defaultValue = 0}) => (_store[key] as int?) ?? defaultValue;

  @override
  Future<bool> setInt(String key, int value) async {
    _store[key] = value;
    return true;
  }

  @override
  String getString(String key, {String defaultValue = ''}) => (_store[key] as String?) ?? defaultValue;

  @override
  Future<bool> setString(String key, String value) async {
    _store[key] = value;
    return true;
  }
}

class MockWakelockPlusService implements IWakelockPlusService {
  bool _enabled = false;
  int enableCalls = 0;
  int disableCalls = 0;

  @override
  bool get enabled => _enabled;

  @override
  Future<void> enable() async {
    _enabled = true;
    enableCalls++;
  }

  @override
  Future<void> disable() async {
    _enabled = false;
    disableCalls++;
  }
}
