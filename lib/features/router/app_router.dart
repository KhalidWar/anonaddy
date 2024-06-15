import 'dart:developer';

import 'package:anonaddy/features/account/presentation/account_tab.dart';
import 'package:anonaddy/features/alert_center/presentation/notifications_screen.dart';
import 'package:anonaddy/features/aliases/presentation/alias_screen.dart';
import 'package:anonaddy/features/aliases/presentation/aliases_tab.dart';
import 'package:anonaddy/features/app_startup/presentation/app_startup_screen.dart';
import 'package:anonaddy/features/app_startup/presentation/controller/app_startup_provider.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/features/auth/presentation/lock_screen.dart';
import 'package:anonaddy/features/create_alias/presentation/create_alias.dart';
import 'package:anonaddy/features/domains/domain/domain.dart';
import 'package:anonaddy/features/domains/presentation/domain_screen.dart';
import 'package:anonaddy/features/domains/presentation/domains_tab.dart';
import 'package:anonaddy/features/home/presentation/home_screen.dart';
import 'package:anonaddy/features/onboarding/presentation/onboarding_screen.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_screen.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_tab.dart';
import 'package:anonaddy/features/router/routes.dart';
import 'package:anonaddy/features/rules/presentation/rules_tab.dart';
import 'package:anonaddy/features/search/presentation/quick_search_screen.dart';
import 'package:anonaddy/features/search/presentation/search_tab.dart';
import 'package:anonaddy/features/settings/presentation/about_app_screen.dart';
import 'package:anonaddy/features/settings/presentation/credits_screen.dart';
import 'package:anonaddy/features/settings/presentation/settings_screen.dart';
import 'package:anonaddy/features/usernames/presentation/usernames_screen.dart';
import 'package:anonaddy/features/usernames/presentation/usernames_tab.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_router.gr.dart';

final appRouterProvider = Provider((ref) {
  final appStartupState = ref.watch(appStartupProvider);

  return AppRouter(
    redirect: (NavigationResolver resolver, StackRouter router) async {
      log('Redirecting to ${resolver.route.fullPath}');

      /// If app startup state is loading or has error, redirect to AppStartupScreen
      /// so that the app can show the loading screen or error screen.
      if (appStartupState.isLoading || appStartupState.hasError) {
        /// If the current route is AppStartupScreen, continue to the next route.
        /// This check is repeated at every navigation because it prevents infinite loop
        /// due to [ref.watch] rebuilds. I will try to find a better solution.
        if (resolver.route.name == AppStartupScreenRoute.name) {
          return resolver.next();
        }

        router.push(const AppStartupScreenRoute());
        return resolver.next(false);
      }

      /// [authNotifierProvider] handles authentication state.
      ///
      /// It's safe to call [.requireValue] because [appStartupProvider]
      /// preloaded [authNotifierProvider] and and handles error cases.
      final authState = ref.watch(authNotifierProvider).requireValue;

      if (authState.isLoggedIn) {
        if (authState.isBiometricLocked) {
          if (resolver.route.name == LockScreenRoute.name) {
            return resolver.next();
          }

          router.push(const LockScreenRoute());
          return resolver.next(false);
        }

        return resolver.next();
      }

      if (!authState.isLoggedIn) {
        if (resolver.route.name == OnboardingScreenRoute.name) {
          return resolver.next();
        }

        router.push(const OnboardingScreenRoute());
        return resolver.next(false);
      }
    },
  );
});

@AutoRouterConfig()
class AppRouter extends _$AppRouter implements AutoRouteGuard {
  AppRouter({required this.redirect});

  final void Function(NavigationResolver resolver, StackRouter router) redirect;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    return redirect(resolver, router);
  }

  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(
        page: AppRoutes.home.page,
        path: AppRoutes.home.path,
        initial: true,
        children: [
          AutoRoute(
            page: AppRoutes.account.page,
            path: AppRoutes.account.path,
            children: [
              AutoRoute(
                page: AppRoutes.recipients.page,
                path: AppRoutes.recipients.path,
                initial: true,
              ),
              AutoRoute(
                page: AppRoutes.usernames.page,
                path: AppRoutes.usernames.path,
              ),
              AutoRoute(
                page: AppRoutes.domains.page,
                path: AppRoutes.domains.path,
              ),
              AutoRoute(
                page: AppRoutes.rules.page,
                path: AppRoutes.rules.path,
              ),
            ],
          ),
          AutoRoute(
            initial: true,
            page: AppRoutes.aliases.page,
            path: AppRoutes.aliases.path,
          ),
          AutoRoute(
            page: AppRoutes.searchTab.page,
            path: AppRoutes.searchTab.path,
          ),
          AutoRoute(
            page: AppRoutes.createAlias.page,
            path: AppRoutes.createAlias.path,
          ),
        ],
      ),
      AutoRoute(
        page: AppRoutes.alias.page,
        path: AppRoutes.alias.path,
      ),
      AutoRoute(
        page: AppRoutes.recipient.page,
        path: AppRoutes.recipient.path,
      ),
      AutoRoute(
        page: AppRoutes.username.page,
        path: AppRoutes.username.path,
      ),
      AutoRoute(
        page: AppRoutes.domain.page,
        path: AppRoutes.domain.path,
      ),
      // AutoRoute(
      //   page: AppRoutes.rule.page,
      //   path: AppRoutes.rule.path,
      // ),
      AutoRoute(
        page: AppRoutes.notifications.page,
        path: AppRoutes.notifications.path,
      ),
      AutoRoute(
        page: AppRoutes.quickSearch.page,
        path: AppRoutes.quickSearch.path,
      ),
      AutoRoute(
        page: AppRoutes.settings.page,
        path: AppRoutes.settings.path,
      ),
      AutoRoute(
        page: AppRoutes.aboutApp.page,
        path: AppRoutes.aboutApp.path,
      ),
      AutoRoute(
        page: AppRoutes.credits.page,
        path: AppRoutes.credits.path,
      ),
      AutoRoute(
        page: AppRoutes.onboarding.page,
        path: AppRoutes.onboarding.path,
      ),
      AutoRoute(
        page: AppRoutes.appStartup.page,
        path: AppRoutes.appStartup.path,
      ),
      AutoRoute(
        page: AppRoutes.lockScreen.page,
        path: AppRoutes.lockScreen.path,
      ),
    ];
  }
}
