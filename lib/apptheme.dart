import 'package:flutter/material.dart';

class AppTheme {
  static var light = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 153, 0, 0),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 153, 0, 0)),
  );
}
