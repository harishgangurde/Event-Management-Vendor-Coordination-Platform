import 'package:flutter/material.dart';

class AppTheme {
  static const Color kPrimaryColor = Color(0xFF7F06F9);
  static const Color kAccentPurple = Color(0xFFA564E9);
  static const Color kBackgroundDark = Color(0xFF100819);
  static const Color kCardDarkColor = Color(0xFF1E122D);
  static const Color kSuccessColor = Color(0xFF27AE60);
  static const Color backgroundLight = Color(0xFFF7F5F8);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: kPrimaryColor,
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: 'Roboto',
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: kBackgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kAccentPurple,
      surface: kCardDarkColor,
    ),
    useMaterial3: true,
  );
}