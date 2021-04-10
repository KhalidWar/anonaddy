import 'package:anonaddy/screens/secure_app_screen/secure_app_screen.dart';
import 'package:anonaddy/services/lifecycle_service/lifecycle_service.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    /// Phoenix restarts app upon logout
    Phoenix(
      /// Riverpod base widget to store provider state
      child: ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

/// ConsumerWidget is used to update state using ChangeNotifierProvider
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    /// Use [watch] method to access different providers
    final themeProvider = watch(settingsStateManagerProvider);

    /// Sets StatusBarColor across the app
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

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
