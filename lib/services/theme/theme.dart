import 'package:flutter/material.dart';

import '../../constants.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  primaryColorLight: Colors.white,
  primaryColorDark: Color(0xFFF5F7FA),
  appBarTheme: appBarTheme,
  toggleableActiveColor: Color(0xFF62F4EB),
  accentColor: kAccentColor,
  buttonTheme: buttonThemeData,
  cardTheme: cardTheme,
  dialogTheme: dialogTheme,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  primaryColorLight: Color(0xFF0d0d0d),
  primaryColorDark: Colors.black,
  appBarTheme: appBarTheme,
  toggleableActiveColor: kAccentColor,
  accentColor: kAccentColor,
  buttonTheme: buttonThemeData,
  cardTheme: cardTheme.copyWith(color: Color(0xFF0d0d0d)),
  dialogTheme: dialogTheme.copyWith(backgroundColor: Color(0xFF0f0f0f)),
);

ButtonThemeData buttonThemeData = ButtonThemeData().copyWith(
  buttonColor: Color(0xFF62F4EB),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

CardTheme cardTheme = CardTheme().copyWith(
  elevation: 6,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
);

DialogTheme dialogTheme = DialogTheme().copyWith(
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: BorderSide(style: BorderStyle.solid, color: kBlueNavyColor),
  ),
);

AppBarTheme appBarTheme = AppBarTheme().copyWith(
  color: kBlueNavyColor,
  brightness: Brightness.dark,
);
