import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../data/effigy.dart';
import '../domain/effigy.dart';

class SettingsProvider extends ChangeNotifier {
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

  final SharedPreferences prefs;

  bool _keepAwake;
  bool get keepAwake => _keepAwake;

  bool _fadeEnabled;
  bool get fadeEnabled => _fadeEnabled;

  int _fadeMinutes;
  int get fadeMinutes => _fadeMinutes;

  SettingsProvider(this.prefs)
    : _keepAwake = prefs.getBool(_keepAwakeKey) ?? false,
      _fadeEnabled = prefs.getBool(_fadeEnabledKey) ?? false,
      _fadeMinutes = (prefs.getInt(_fadeMinutesKey) ?? 5).clamp(1, 60);

  Future<void> init() async {
    if (_keepAwake) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
  }

  Future<void> setKeepAwake(bool value) async {
    _keepAwake = value;
    await prefs.setBool(_keepAwakeKey, value);

    if (value) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
    notifyListeners();
  }

  Future<void> setFadeEnabled(bool value) async {
    _fadeEnabled = value;
    await prefs.setBool(_fadeEnabledKey, value);
    notifyListeners();
  }

  Future<void> setFadeMinutes(int minutes) async {
    _fadeMinutes = minutes.clamp(1, 60);
    await prefs.setInt(_fadeMinutesKey, _fadeMinutes);
    notifyListeners();
  }
}
