import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './provider/settings.dart';
import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final prefs = await SharedPreferences.getInstance();
  final settingsProvider = SettingsProvider(prefs);
  await settingsProvider.init();

  runApp(MultiProvider(providers: [ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider)], child: const App()));
}
