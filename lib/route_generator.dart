import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/screens/account_tab/domains/domain_detailed_screen.dart';
import 'package:anonaddy/screens/account_tab/recipients/recipient_detailed_screen.dart';
import 'package:anonaddy/screens/account_tab/usernames/username_detailed_screen.dart';
import 'package:anonaddy/screens/alias_tab/alias_detailed_screen.dart';
import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/screens/home_screen_components/alert_center/alert_center_screen.dart';
import 'package:anonaddy/screens/home_screen_components/settings_screen/about_app_screen.dart';
import 'package:anonaddy/screens/home_screen_components/settings_screen/credits_screen.dart';
import 'package:anonaddy/screens/home_screen_components/settings_screen/settings_screen.dart';
import 'package:anonaddy/screens/login_screen/anonaddy_login_screen.dart';
import 'package:anonaddy/screens/login_screen/self_host_login_screen.dart';
import 'package:anonaddy/screens/navigation_errror/navigation_error_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/domain/domain_model.dart';

class RouteGenerator {
  /// Route Names
  static const splashScreen = 'splashScreen';
  static const loginScreen = 'loginScreen';
  static const selfHostedScreen = 'selfHostedScreen';
  static const initialScreen = 'initialScreen';

  static const secureAppScreen = 'secureAppScreen';
  static const secureGateScreen = 'secureGateScreen';

  static const homeScreen = 'homeScreen';

  static const aliasDetailedScreen = 'aliasDetailedScreen';
  static const recipientDetailedScreen = 'recipientDetailedScreen';
  static const usernameDetailedScreen = 'usernameDetailedScreen';
  static const domainDetailedScreen = 'domainDetailedScreen';

  static const failedDeliveriesScreen = 'failedDeliveriesScreen';

  static const settingsScreen = 'settingsScreen';
  static const aboutAppScreen = 'aboutAppScreen';
  static const creditsScreen = 'creditsScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argument = settings.arguments;

    /// Custom page route animation
    PageRouteBuilder customPageRoute(Widget child) {
      return PageRouteBuilder(
        transitionsBuilder: (context, animation, secondAnimation, child) {
          final tween = Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0));
          animation =
              CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut);
          return SlideTransition(
            position: tween.animate(animation),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondAnimation) => child,
      );
    }

    switch (settings.name) {

      /// Home Screen
      case homeScreen:
        return customPageRoute(HomeScreen());
      case failedDeliveriesScreen:
        return customPageRoute(AlertCenterScreen());

      /// Settings Screen
      case settingsScreen:
        return customPageRoute(SettingsScreen());
      case aboutAppScreen:
        return customPageRoute(AboutAppScreen());
      case creditsScreen:
        return customPageRoute(CreditsScreen());

      /// Alias Tab
      case aliasDetailedScreen:
        return customPageRoute(AliasDetailScreen(argument as Alias));

      /// Account Tab
      case recipientDetailedScreen:
        return customPageRoute(
            RecipientDetailedScreen(recipient: argument as Recipient));
      case usernameDetailedScreen:
        return customPageRoute(
            UsernameDetailedScreen(username: argument as Username));
      case domainDetailedScreen:
        return customPageRoute(
            DomainDetailedScreen(domain: argument as Domain));

      /// Login Screen
      case loginScreen:
        return customPageRoute(AnonAddyLoginScreen());
      case selfHostedScreen:
        return customPageRoute(SelfHostLoginScreen());

      /// Show ErrorScreen if screen doesn't exist or something goes wrong
      default:
        return customPageRoute(NavigationErrorScreen());
    }
  }
}
