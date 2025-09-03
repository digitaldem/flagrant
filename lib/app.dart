import 'package:flutter/material.dart';

import './provider/settings.dart';
import './presentation/themes/default.dart';
import './presentation/body.dart';
import './presentation/bottom_bar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: DefaultTheme.theme,
      home: OrientationBuilder(
        builder: (context, orientation) {
          final effigy = SettingsProvider.effigies[orientation];
          return Scaffold(
            body: (effigy != null) ? Body(effigy: effigy) : SizedBox.shrink(),
            bottomNavigationBar: (effigy != null && effigy.showBottomBar) ? BottomBar() : null,
          );
        },
      ),
    );
  }
}
