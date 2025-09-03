import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './data/shared_preferences.dart';
import './data/wakelock.dart';
import './provider/settings.dart';
import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final prefs = await SharedPreferencesService.create();
  final wakelock = await WakelockPlusService.create();
  final settingsProvider = await SettingsProvider.create(prefs, wakelock);

  runApp(MultiProvider(providers: [ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider)], child: const App()));
}
