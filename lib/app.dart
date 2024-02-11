import 'dart:io';

import 'package:anonaddy/features/auth/presentation/auth_screen.dart';
import 'package:anonaddy/features/settings/presentation/controller/settings_notifier.dart';
import 'package:anonaddy/route_generator.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

/// ConsumerWidget is used to update state using ChangeNotifierProvider
class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Use [watch] method to access different providers
    final settingsState = ref.watch(settingsNotifier).value;

    /// Sets StatusBarColor for the whole app
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    if (Platform.isMacOS) {
      return MacosApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: settingsState?.isDarkTheme ?? false
            ? AppTheme.macOSThemeDark
            : AppTheme.macOSThemeLight,
        darkTheme: AppTheme.macOSThemeDark,
        themeMode: ThemeMode.light,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: AuthScreen.routeName,
        locale: const Locale('en', 'US'),
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      );
    }

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme:
          settingsState?.isDarkTheme ?? false ? AppTheme.dark : AppTheme.light,
      darkTheme: AppTheme.dark,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: AuthScreen.routeName,
      locale: const Locale('en', 'US'),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
