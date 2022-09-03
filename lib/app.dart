import 'dart:io';

import 'package:anonaddy/route_generator.dart';
import 'package:anonaddy/screens/authorization_screen/authorization_screen.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/notifiers/settings/settings_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

/// ConsumerWidget is used to update state using ChangeNotifierProvider
class App extends ConsumerStatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    ref.read(settingsStateNotifier.notifier).loadSettingsState();
  }

  @override
  Widget build(BuildContext context) {
    /// Use [watch] method to access different providers
    final settingsState = ref.watch(settingsStateNotifier);

    /// Sets StatusBarColor for the whole app
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    if (Platform.isMacOS) {
      return MacosApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: settingsState.isDarkTheme
            ? AppTheme.macOSThemeDark
            : AppTheme.macOSThemeLight,
        darkTheme: AppTheme.macOSThemeDark,
        themeMode: ThemeMode.light,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: AuthorizationScreen.routeName,
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
      theme: settingsState.isDarkTheme ? AppTheme.dark : AppTheme.light,
      darkTheme: AppTheme.dark,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: AuthorizationScreen.routeName,
      locale: const Locale('en', 'US'),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
