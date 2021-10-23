import 'package:anonaddy/screens/authorization_screen/authorization_screen.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/state_management/settings_state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../route_generator.dart';

class PlatformApp extends PlatformAware {
  const PlatformApp({required this.settingsState});
  final SettingsStateManager settingsState;

  static const _englishLocale = const Locale('en', 'US');
  static const _defaultLocalizations = [
    DefaultMaterialLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
    DefaultWidgetsLocalizations.delegate,
  ];

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return Material(
      child: CupertinoApp(
        title: kAppBarTitle,
        debugShowCheckedModeBanner: false,
        //todo fix darkTheme for iOS
        // theme: CupertinoThemeData(
        //   brightness:
        //       settingsState.isDarkTheme ? Brightness.dark : Brightness.light,
        //   // primaryColor: kPrimaryColor,
        // ),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: AuthorizationScreen.routeName,
        localizationsDelegates: _defaultLocalizations,
        locale: _englishLocale,
      ),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return MaterialApp(
      title: kAppBarTitle,
      debugShowCheckedModeBanner: false,
      theme: settingsState.isDarkTheme ? darkTheme : lightTheme,
      darkTheme: darkTheme,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: AuthorizationScreen.routeName,
      localizationsDelegates: _defaultLocalizations,
      locale: _englishLocale,
    );
  }
}
