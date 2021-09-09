import 'package:anonaddy/screens/account_tab/domains/domain_detailed_screen.dart';
import 'package:anonaddy/screens/account_tab/recipients/recipient_detailed_screen.dart';
import 'package:anonaddy/screens/account_tab/usernames/username_detailed_screen.dart';
import 'package:anonaddy/screens/alias_tab/alias_detailed_screen.dart';
import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/screens/home_screen_componenets/alert_center/alert_center_screen.dart';
import 'package:anonaddy/screens/home_screen_componenets/settings_screen/about_app_screen.dart';
import 'package:anonaddy/screens/home_screen_componenets/settings_screen/credits_screen.dart';
import 'package:anonaddy/screens/home_screen_componenets/settings_screen/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Route Names
const splashScreen = 'splashScreen';
const loginScreen = 'loginScreen';
const selfHostedScreen = 'selfHostedScreen';

const initialScreen = 'initialScreen';

const secureAppScreen = 'secureAppScreen';
const secureGateScreen = 'secureGateScreen';

const homeScreen = 'homeScreen';

const aliasDetailedScreen = 'aliasDetailedScreen';
const recipientDetailedScreen = 'recipientDetailedScreen';
const usernameDetailedScreen = 'usernameDetailedScreen';
const domainDetailedScreen = 'domainDetailedScreen';

const failedDeliveriesScreen = 'failedDeliveriesScreen';

const settingsScreen = 'settingsScreen';
const aboutAppScreen = 'aboutAppScreen';
const creditsScreen = 'creditsScreen';

/// Router
Route<dynamic> router(RouteSettings settings) {
  switch (settings.name) {
    case homeScreen:
      return customPageRoute(HomeScreen());
    case failedDeliveriesScreen:
      return customPageRoute(AlertCenterScreen());
    case aliasDetailedScreen:
      return customPageRoute(AliasDetailScreen());
    case recipientDetailedScreen:
      final argument = settings.arguments as Map<String, dynamic>;
      return customPageRoute(
          RecipientDetailedScreen(recipientData: argument['recipient']));
    case usernameDetailedScreen:
      return customPageRoute(UsernameDetailedScreen());
    case domainDetailedScreen:
      final argument = settings.arguments as Map<String, dynamic>;
      return customPageRoute(DomainDetailedScreen(domain: argument['domain']));

    /// Settings
    case settingsScreen:
      return customPageRoute(SettingsScreen());
    case aboutAppScreen:
      return customPageRoute(AboutAppScreen());
    case creditsScreen:
      return customPageRoute(CreditsScreen());

    default:
      throw 'Error';
  }
}

/// Custom Page Route
Route<dynamic> customPageRoute(Widget child) {
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
