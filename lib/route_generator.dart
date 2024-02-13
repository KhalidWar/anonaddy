import 'package:anonaddy/features/alert_center/presentation/alert_center_screen.dart';
import 'package:anonaddy/features/aliases/presentation/alias_screen.dart';
import 'package:anonaddy/features/auth/presentation/anonaddy_login_screen.dart';
import 'package:anonaddy/features/auth/presentation/auth_screen.dart';
import 'package:anonaddy/features/auth/presentation/logout_screen.dart';
import 'package:anonaddy/features/auth/presentation/self_host_login_screen.dart';
import 'package:anonaddy/features/domains/domain/domain_model.dart';
import 'package:anonaddy/features/domains/presentation/domains_screen.dart';
import 'package:anonaddy/features/home/presentation/home_screen.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_screen.dart';
import 'package:anonaddy/features/search/presentation/quick_search_screen.dart';
import 'package:anonaddy/features/settings/presentation/about_app_screen.dart';
import 'package:anonaddy/features/settings/presentation/credits_screen.dart';
import 'package:anonaddy/features/settings/presentation/settings_screen.dart';
import 'package:anonaddy/features/usernames/presentation/usernames_screen.dart';
import 'package:anonaddy/shared_components/navigation_error/navigation_error_screen.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argument = settings.arguments;

    switch (settings.name) {
      /// Authentication Screen
      case AuthScreen.routeName:
        return PlatformAware.customPageRoute(const AuthScreen());

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
          AliasScreen(aliasId: argument as String),
        );

      /// Account Tab
      case RecipientsScreen.routeName:
        return PlatformAware.customPageRoute(
            RecipientsScreen(recipient: argument as Recipient));
      case UsernamesScreen.routeName:
        return PlatformAware.customPageRoute(
            UsernamesScreen(usernameId: argument as String));
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
