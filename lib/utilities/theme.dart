import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  primaryColorLight: Colors.white,
  primaryColorDark: Color(0xFFF5F7FA),
  scaffoldBackgroundColor: Color(0xFFF5F7FA),
  appBarTheme: appBarTheme,
  toggleableActiveColor: Color(0xFF62F4EB),
  accentColor: Color(0xFF62F4EB),
  buttonTheme: buttonThemeData,
  cardTheme: cardTheme,
  dialogTheme: dialogTheme,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  primaryColorLight: Color(0xFF0d0d0d),
  primaryColorDark: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: appBarTheme,
  toggleableActiveColor: Color(0xFF62F4EB),
  accentColor: Color(0xFF62F4EB),
  buttonTheme: buttonThemeData,
  cardTheme: cardTheme.copyWith(color: Color(0xFF0d0d0d)),
  dialogTheme: dialogTheme.copyWith(backgroundColor: Color(0xFF0f0f0f)),
);

ButtonThemeData buttonThemeData = ButtonThemeData(
  buttonColor: Color(0xFF62F4EB),
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10))),
);

CardTheme cardTheme = CardTheme(
  elevation: 8,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

DialogTheme dialogTheme = DialogTheme(
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(style: BorderStyle.solid, color: Colors.red)),
);

AppBarTheme appBarTheme = AppBarTheme(color: Color(0xFF19216C));
