import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/models/username/username.dart';
import 'package:anonaddy/screens/account_tab/domains/domains_screen.dart';
import 'package:anonaddy/screens/account_tab/recipients/recipients_screen.dart';
import 'package:anonaddy/screens/account_tab/usernames/usernames_screen.dart';
import 'package:anonaddy/screens/alert_center/alert_center_screen.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:anonaddy/screens/authorization_screen/authorization_screen.dart';
import 'package:anonaddy/screens/authorization_screen/logout_screen.dart';
import 'package:anonaddy/screens/home_screen/home_screen.dart';
import 'package:anonaddy/screens/login_screen/anonaddy_login_screen.dart';
import 'package:anonaddy/screens/login_screen/self_host_login_screen.dart';
import 'package:anonaddy/screens/navigation_error/navigation_error_screen.dart';
import 'package:anonaddy/screens/search_tab/quick_search_screen.dart';
import 'package:anonaddy/screens/settings_screen/about_app_screen.dart';
import 'package:anonaddy/screens/settings_screen/credits_screen.dart';
import 'package:anonaddy/screens/settings_screen/settings_screen.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argument = settings.arguments;

    switch (settings.name) {

      /// Authentication Screen
      case AuthorizationScreen.routeName:
        return PlatformAware.customPageRoute(const AuthorizationScreen());

      /// Home Screen
      case HomeScreen.routeName:
        return PlatformAware.customPageRoute(const HomeScreen());
      case AlertCenterScreen.routeName:
        return PlatformAware.customPageRoute(const AlertCenterScreen());
      case QuickSearchScreen.routeName:
        return PlatformAware.customPageRoute(const QuickSearchScreen());

      /// Settings Screen
      case SettingsScreen.routeName:
        return PlatformAware.customPageRoute(const SettingsScreen());
      case AboutAppScreen.routeName:
        return PlatformAware.customPageRoute(const AboutAppScreen());
      case CreditsScreen.routeName:
        return PlatformAware.customPageRoute(const CreditsScreen());

      /// Alias Tab
      case AliasScreen.routeName:
        return PlatformAware.customPageRoute(
          AliasScreen(alias: argument as Alias),
        );

      /// Account Tab
      case RecipientsScreen.routeName:
        return PlatformAware.customPageRoute(
            RecipientsScreen(recipient: argument as Recipient));
      case UsernamesScreen.routeName:
        return PlatformAware.customPageRoute(
            UsernamesScreen(username: argument as Username));
      case DomainsScreen.routeName:
        return PlatformAware.customPageRoute(
            DomainsScreen(domain: argument as Domain));

      /// Login Screen
      case AnonAddyLoginScreen.routeName:
        return PlatformAware.customPageRoute(const AnonAddyLoginScreen());
      case SelfHostLoginScreen.routeName:
        return PlatformAware.customPageRoute(const SelfHostLoginScreen());

      /// Logout Screen
      case LogoutScreen.routeName:
        return PlatformAware.customPageRoute(const LogoutScreen());

      /// Show ErrorScreen if screen doesn't exist or something goes wrong
      default:
        return PlatformAware.customPageRoute(const NavigationErrorScreen());
    }
  }
}
