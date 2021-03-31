import 'package:anonaddy/screens/secure_app_screen/secure_app_screen.dart';
import 'package:anonaddy/services/lifecycle_service/lifecycle_service.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    /// Riverpod base widget to store provider state
    ProviderScope(
      child: MyApp(),
    ),
  );
}

/// ConsumerWidget is used to update state using ChangeNotifierProvider
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    /// Use [watch] method to access different providers
    final themeProvider = watch(themeServiceProvider);

    return LifecycleService(
      child: MaterialApp(
        title: 'AddyManager',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.isDarkTheme ? darkTheme : lightTheme,
        darkTheme: darkTheme,
        home: SecureAppScreen(),
      ),
    );
  }
}
