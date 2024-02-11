import 'package:flutter/material.dart';

class AuthScreenWidgetKeys {
  /// Loading Screen
  static const loadingScreenScaffold = Key('loadingScreenScaffold');
  static const loadingScreenAppLogo = Key('loadingScreenAppLogo');
  static const loadingScreenLoadingIndicator =
      Key('loadingScreenLoadingIndicator');
  static const loadingScreenLogoutButton = Key('loadingScreenLogoutButton');

  /// Authorization Screen
  static const authScreenLoadingScreen = Key('authScreenLoadingScreen');
  static const authScreenHomeScreen = Key('authScreenHomeScreen');
  static const authScreenAnonAddyLoginScreen =
      Key('authScreenAnonAddyLoginScreen');
  static const authScreenSelfHostedLoginScreen =
      Key('authScreenSelfHostedLoginScreen');
}
