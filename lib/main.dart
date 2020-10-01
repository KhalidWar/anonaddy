import 'package:anonaddy/screens/initial_screen.dart';
import 'package:anonaddy/services/theme_manager.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeManager>(
      create: (_) => ThemeManager(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: 'AnonAddy',
            debugShowCheckedModeBanner: false,
            theme: themeManager.isDarkTheme ? darkTheme : lightTheme,
            darkTheme: darkTheme,
            home: InitialScreen(),
          );
        },
      ),
    );
  }
}
