import 'package:flutter/material.dart';

import '../../constants.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  primaryColorLight: Colors.white,
  primaryColorDark: Color(0xFFF5F7FA),
  appBarTheme: appBarTheme,
  toggleableActiveColor: Color(0xFF62F4EB),
  accentColor: kAccentColor,
  buttonTheme: buttonThemeData,
  floatingActionButtonTheme: fabThemeData,
  cardTheme: cardTheme,
  dialogTheme: dialogTheme,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.black,
  primaryColorLight: Color(0xFF0d0d0d),
  primaryColorDark: Colors.black,
  appBarTheme: appBarTheme,
  toggleableActiveColor: kAccentColor,
  accentColor: kAccentColor,
  dividerColor: Colors.grey[600],
  buttonTheme: buttonThemeData,
  floatingActionButtonTheme: fabThemeData,
  cardTheme: cardTheme.copyWith(color: Color(0xFF141414)),
  dialogTheme: dialogTheme.copyWith(backgroundColor: Color(0xFF0f0f0f)),
  bottomNavigationBarTheme:
      BottomNavigationBarThemeData(backgroundColor: Colors.black),
);

ButtonThemeData buttonThemeData = ButtonThemeData().copyWith(
  buttonColor: Color(0xFF62F4EB),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

CardTheme cardTheme = CardTheme().copyWith(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
);

DialogTheme dialogTheme = DialogTheme().copyWith(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    side: BorderSide(style: BorderStyle.solid, color: kBlueNavyColor),
  ),
);

AppBarTheme appBarTheme = AppBarTheme().copyWith(
  color: kBlueNavyColor,
  brightness: Brightness.dark,
);

FloatingActionButtonThemeData fabThemeData =
    FloatingActionButtonThemeData().copyWith(
  backgroundColor: Color(0xFF62F4EB),
  foregroundColor: Colors.black,
);
