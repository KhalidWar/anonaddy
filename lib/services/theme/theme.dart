import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  primaryColorLight: Colors.white,
  primaryColorDark: const Color(0xFFF5F7FA),
  appBarTheme: appBarTheme,
  toggleableActiveColor: kAccentColor,
  accentColor: kAccentColor,
  buttonTheme: buttonThemeData,
  floatingActionButtonTheme: fabThemeData,
  cardTheme: cardTheme,
  dialogTheme: dialogTheme,
  elevatedButtonTheme: elevatedButtonThemeData,
);

final darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.black,
  primaryColorLight: const Color(0xFF0d0d0d),
  primaryColorDark: Colors.black,
  appBarTheme: appBarTheme,
  toggleableActiveColor: kAccentColor,
  accentColor: kAccentColor,
  dividerColor: Colors.grey[600],
  buttonTheme: buttonThemeData,
  floatingActionButtonTheme: fabThemeData,
  cardTheme: cardTheme.copyWith(color: const Color(0xFF141414)),
  dialogTheme: dialogTheme,
  bottomNavigationBarTheme:
      const BottomNavigationBarThemeData(backgroundColor: Colors.black),
  elevatedButtonTheme: elevatedButtonThemeData,
);

final elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all(Colors.black),
    overlayColor: MaterialStateProperty.all(kPrimaryColor),
    backgroundColor: MaterialStateProperty.all(kAccentColor),
    minimumSize: MaterialStateProperty.all(const Size(180, 50)),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
  ),
);

final buttonThemeData = const ButtonThemeData().copyWith(
  buttonColor: const Color(0xFF62F4EB),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(6)),
  ),
);

final cardTheme = const CardTheme().copyWith(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
);

final dialogTheme = const DialogTheme().copyWith(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
);

final appBarTheme = const AppBarTheme().copyWith(
  color: kPrimaryColor,
  brightness: Brightness.dark,
);

final fabThemeData = const FloatingActionButtonThemeData().copyWith(
  backgroundColor: const Color(0xFF62F4EB),
  foregroundColor: Colors.black,
);

/// UI Decoration
const kBottomSheetBorderRadius = 12.0;
const kTextFormFieldDecoration = InputDecoration(
  border: OutlineInputBorder(),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: kAccentColor)),
);
