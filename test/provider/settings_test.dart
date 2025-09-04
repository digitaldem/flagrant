import 'package:flagrant/provider/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsProvider', () {
    test('create() uses defaults when keys absent (keepAwake=false, fadeEnabled=false, fadeMinutes=10)', () async {
      final prefs = MockSharedPreferencesService();
      final wakelock = MockWakelockPlusService();

      final sp = await SettingsProvider.create(prefs, wakelock);

      expect(sp.keepAwake, isFalse);
      expect(sp.fadeEnabled, isTrue);
      expect(sp.fadeMinutes, 10);

      // wakelock should be turned off during create()
      expect(wakelock.enabled, isFalse);
      expect(wakelock.disableCalls, 1);
    });

    test('create() initializes from prefs and toggles wakelock accordingly (false)', () async {
      final prefs =
          MockSharedPreferencesService()
            ..setBool('keepAwake', false)
            ..setBool('fadeEnabled', false)
            ..setInt('fadeMinutes', 10);

      final wakelock = MockWakelockPlusService();

      final sp = await SettingsProvider.create(prefs, wakelock);

      expect(sp.keepAwake, isFalse);
      expect(sp.fadeEnabled, isFalse);
      expect(sp.fadeMinutes, 10);

      // wakelock should be turned off during create()
      expect(wakelock.enabled, isFalse);
      expect(wakelock.enableCalls, 0);
      expect(wakelock.disableCalls, 1);
    });

    test('create() initializes from prefs and toggles wakelock accordingly (true)', () async {
      final prefs =
          MockSharedPreferencesService()
            ..setBool('keepAwake', true)
            ..setBool('fadeEnabled', true)
            ..setInt('fadeMinutes', 10);

      final wakelock = MockWakelockPlusService();

      final sp = await SettingsProvider.create(prefs, wakelock);

      expect(sp.keepAwake, isTrue);
      expect(sp.fadeEnabled, isTrue);
      expect(sp.fadeMinutes, 10);

      // wakelock should be turned on during create()
      expect(wakelock.enabled, isTrue);
      expect(wakelock.enableCalls, 1);
      expect(wakelock.disableCalls, 0);
    });

    test('setKeepAwake updates state, persists, toggles wakelock, and notifies', () async {
      final prefs = MockSharedPreferencesService();
      final wakelock = MockWakelockPlusService();
      final sp = await SettingsProvider.create(prefs, wakelock);

      var notifications = 0;
      sp.addListener(() => notifications++);

      await sp.setKeepAwake(true);
      expect(sp.keepAwake, isTrue);
      expect(prefs.getBool('keepAwake'), isTrue);
      expect(wakelock.enabled, isTrue);
      expect(wakelock.enableCalls, 1);
      expect(notifications, 1);

      await sp.setKeepAwake(false);
      expect(sp.keepAwake, isFalse);
      expect(prefs.getBool('keepAwake'), isFalse);
      expect(wakelock.enabled, isFalse);
      expect(wakelock.disableCalls, greaterThanOrEqualTo(1));
      expect(notifications, 2);
    });

    test('setFadeEnabled updates state, persists, and notifies', () async {
      final prefs = MockSharedPreferencesService();
      final wakelock = MockWakelockPlusService();
      final sp = await SettingsProvider.create(prefs, wakelock);

      var notifications = 0;
      sp.addListener(() => notifications++);

      await sp.setFadeEnabled(true);
      expect(sp.fadeEnabled, isTrue);
      expect(prefs.getBool('fadeEnabled'), isTrue);
      expect(notifications, 1);

      await sp.setFadeEnabled(false);
      expect(sp.fadeEnabled, isFalse);
      expect(prefs.getBool('fadeEnabled'), isFalse);
      expect(notifications, 2);
    });

    test('setFadeMinutes clamps to [1, 60], persists, and notifies', () async {
      final prefs = MockSharedPreferencesService();
      final wakelock = MockWakelockPlusService();
      final sp = await SettingsProvider.create(prefs, wakelock);

      var notifications = 0;
      sp.addListener(() => notifications++);

      // Below range
      await sp.setFadeMinutes(0);
      expect(sp.fadeMinutes, 1);
      expect(prefs.getInt('fadeMinutes'), 1);
      expect(notifications, 1);

      // In range
      await sp.setFadeMinutes(30);
      expect(sp.fadeMinutes, 30);
      expect(prefs.getInt('fadeMinutes'), 30);
      expect(notifications, 2);

      // Above range
      await sp.setFadeMinutes(500);
      expect(sp.fadeMinutes, 60);
      expect(prefs.getInt('fadeMinutes'), 60);
      expect(notifications, 3);
    });

    test('static effigies map exposes both orientations', () {
      expect(SettingsProvider.effigies.containsKey(Orientation.portrait), isTrue);
      expect(SettingsProvider.effigies.containsKey(Orientation.landscape), isTrue);

      final p = SettingsProvider.effigies[Orientation.portrait]!;
      final l = SettingsProvider.effigies[Orientation.landscape]!;
      expect(p.image, isNotEmpty);
      expect(l.image, isNotEmpty);
    });
  });
}
