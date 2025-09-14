import 'package:flutter/material.dart';

import '../data/effigy.dart';
import '../domain/effigy.dart';
import '../domain/shared_preferences.dart';
import '../domain/wakelock.dart';

class SettingsProvider extends ChangeNotifier {
  static const String appVersion = '1.0.0';
  static const String appAuthor = 'digitaldementia';
  static const int appCopyrightYear = 2025;
  static const String appPrivacyPolicyUrl = 'https://digitaldementia.com/privacy.html';

  static const Map<Orientation, IEffigy> effigies = {
    Orientation.portrait: Effigy(
      image: 'assets/images/djt_portrait.png',
      lottie: 'assets/lottie/fire_portrait.json',
      xScale: 1.5,
      yScale: 3.0,
      showBottomBar: true,
    ),
    Orientation.landscape: Effigy(
      image: 'assets/images/flag_landscape.png',
      lottie: 'assets/lottie/fire_landscape.json',
      xScale: 1.0,
      yScale: 1.5,
      showBottomBar: false,
    ),
  };
  static const _keepAwakeKey = 'keepAwake';
  static const _fadeEnabledKey = 'fadeEnabled';
  static const _fadeMinutesKey = 'fadeMinutes';

  final ISharedPreferencesService sharedPreferences;
  final IWakelockPlusService wakelockPlus;

  bool _keepAwake;
  bool get keepAwake => _keepAwake;

  bool _fadeEnabled;
  bool get fadeEnabled => _fadeEnabled;

  int _fadeMinutes;
  int get fadeMinutes => _fadeMinutes;

  SettingsProvider._(this.sharedPreferences, this.wakelockPlus)
    : _keepAwake = sharedPreferences.getBool(_keepAwakeKey),
      _fadeEnabled = sharedPreferences.getBool(_fadeEnabledKey, defaultValue: true),
      _fadeMinutes = sharedPreferences.getInt(_fadeMinutesKey, defaultValue: 10).clamp(1, 60);

  static Future<SettingsProvider> create(ISharedPreferencesService sharedPreferences, IWakelockPlusService wakelockPlus) async {
    final provider = SettingsProvider._(sharedPreferences, wakelockPlus);
    if (provider.keepAwake) {
      await wakelockPlus.enable();
    } else {
      await wakelockPlus.disable();
    }
    return provider;
  }

  Future<void> setKeepAwake(bool value) async {
    _keepAwake = value;
    await sharedPreferences.setBool(_keepAwakeKey, value);

    if (value) {
      await wakelockPlus.enable();
    } else {
      await wakelockPlus.disable();
    }
    notifyListeners();
  }

  Future<void> setFadeEnabled(bool value) async {
    _fadeEnabled = value;
    await sharedPreferences.setBool(_fadeEnabledKey, value);
    notifyListeners();
  }

  Future<void> setFadeMinutes(int minutes) async {
    _fadeMinutes = minutes.clamp(1, 60);
    await sharedPreferences.setInt(_fadeMinutesKey, _fadeMinutes);
    notifyListeners();
  }
}
