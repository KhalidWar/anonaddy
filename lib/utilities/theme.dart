import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';

class AppTheme {
  static final ThemeData light = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    primaryColorLight: Colors.white,
    primaryColorDark: const Color(0xFFF5F7FA),
    appBarTheme: _appBarTheme,
    toggleableActiveColor: AppColors.accentColor,
    buttonTheme: _buttonThemeData,
    floatingActionButtonTheme: _fabThemeData,
    cardTheme: _cardTheme,
    dialogTheme: _dialogTheme,
    elevatedButtonTheme: _elevatedButtonThemeData,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.accentColor),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.black,
    primaryColorLight: const Color(0xFF0d0d0d),
    primaryColorDark: Colors.black,
    appBarTheme: _appBarTheme,
    toggleableActiveColor: AppColors.accentColor,
    dividerColor: Colors.grey[600],
    buttonTheme: _buttonThemeData,
    floatingActionButtonTheme: _fabThemeData,
    cardTheme: _cardTheme.copyWith(color: const Color(0xFF141414)),
    dialogTheme: _dialogTheme,
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Colors.black),
    elevatedButtonTheme: _elevatedButtonThemeData,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.accentColor),
  );

  static final macOSThemeLight = MacosThemeData.light();

  static final macOSThemeDark = MacosThemeData.dark();

  static final _elevatedButtonThemeData = ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.black),
      overlayColor: MaterialStateProperty.all(AppColors.primaryColor),
      backgroundColor: MaterialStateProperty.all(AppColors.accentColor),
      minimumSize: MaterialStateProperty.all(const Size(180, 50)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    ),
  );

  static final _buttonThemeData = const ButtonThemeData().copyWith(
    buttonColor: AppColors.accentColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
  );

  static final _cardTheme = const CardTheme().copyWith(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
  );

  static final _dialogTheme = const DialogTheme().copyWith(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  static final _appBarTheme = const AppBarTheme().copyWith(
    color: AppColors.primaryColor,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  static final _fabThemeData = const FloatingActionButtonThemeData().copyWith(
    backgroundColor: AppColors.accentColor,
    foregroundColor: Colors.black,
  );

  /// Universal UI Decoration
  static const kBottomSheetBorderRadius = 12.0;
  static const kTextFormFieldDecoration = InputDecoration(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.accentColor),
    ),
  );
}
