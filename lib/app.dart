import 'package:anonaddy/state_management/settings/settings_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'route_generator.dart';
import 'screens/authorization_screen/authorization_screen.dart';
import 'services/theme/theme.dart';
import 'shared_components/constants/app_strings.dart';

/// ConsumerWidget is used to update state using ChangeNotifierProvider
class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Use [watch] method to access different providers
    final settingsState = ref.watch(settingsStateNotifier);

    /// Sets StatusBarColor for the whole app
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    const _defaultLocalizations = [
      DefaultMaterialLocalizations.delegate,
      DefaultCupertinoLocalizations.delegate,
      DefaultWidgetsLocalizations.delegate,
    ];

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: settingsState.isDarkTheme! ? AppTheme.dark : AppTheme.light,
      darkTheme: AppTheme.dark,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: AuthorizationScreen.routeName,
      locale: const Locale('en', 'US'),
      localizationsDelegates: _defaultLocalizations,
    );
  }
}