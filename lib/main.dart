import 'package:anonaddy/screens/login_screen/initial_screen.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/services/theme/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final themeProvider = watch(themeServiceProvider);
    return MaterialApp(
      title: 'AddyManager',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkTheme ? darkTheme : lightTheme,
      //todo fix darkTheme coloring scheme
      // darkTheme: darkTheme,
      home: InitialScreen(),
    );
  }
}
