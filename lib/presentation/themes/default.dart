import 'package:flutter/material.dart';

class DefaultTheme {
  static ThemeData get theme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.black,
      dividerColor: Colors.black26,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.amber;
          }
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.deepOrangeAccent;
          }
          return Colors.grey.shade700;
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.amber),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white70,
        labelTextStyle: WidgetStateProperty.all(TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      iconTheme: IconThemeData(color: Colors.black87),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal),
        labelLarge: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.normal),
        labelSmall: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.normal),
      ),
    );
  }
}
