import 'package:anonaddy/constants.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  primaryColorLight: Colors.white,
  primaryColorDark: Color(0xffefefef),
  scaffoldBackgroundColor: Colors.white,
  toggleableActiveColor: Colors.red,
  accentColor: kAccentColor,
  buttonTheme: buttonThemeData,
  cardTheme: cardTheme,
  dialogTheme: dialogTheme,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  primaryColorLight: Color(0xFF0f0f0f),
  primaryColorDark: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  toggleableActiveColor: Colors.red,
  accentColor: kAccentColor,
  buttonTheme: buttonThemeData,
  cardTheme: cardTheme.copyWith(color: Color(0xFF0f0f0f)),
  dialogTheme: dialogTheme.copyWith(backgroundColor: Color(0xFF0f0f0f)),
);

ButtonThemeData buttonThemeData = ButtonThemeData(
  splashColor: Colors.red,
  highlightColor: Colors.red,
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
