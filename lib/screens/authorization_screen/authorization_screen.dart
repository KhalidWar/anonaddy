import 'dart:io';

import 'package:anonaddy/notifiers/authorization/auth_notifier.dart';
import 'package:anonaddy/notifiers/authorization/auth_state.dart';
import 'package:anonaddy/screens/authorization_screen/components/auth_screen_widget_keys.dart';
import 'package:anonaddy/screens/authorization_screen/error_screen.dart';
import 'package:anonaddy/screens/authorization_screen/loading_screen.dart';
import 'package:anonaddy/screens/authorization_screen/lock_screen.dart';
import 'package:anonaddy/screens/home_screen/home_screen.dart';
import 'package:anonaddy/screens/login_screen/anonaddy_login_screen.dart';
import 'package:anonaddy/screens/login_screen/self_host_login_screen.dart';
import 'package:anonaddy/screens/macos/macos_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_application/secure_application.dart';

/// This widget manages user authentication and authorization
/// flow for the whole app.
class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = 'authorizationScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watches for [authStateNotifier] changes and
    /// updates UI accordingly.
    final authNotifier = ref.watch(authStateNotifier);

    return authNotifier.when(
      data: (authState) {
        switch (authState.authorizationStatus) {
          /// [SecureApplication] package isn't available for MacOS.
          ///
          /// Manages when a logged in user is found
          case AuthorizationStatus.authorized:
            if (Platform.isMacOS) return const MacosScreen();

            switch (authState.authenticationStatus) {
              case AuthenticationStatus.enabled:

                /// Enables app security
                /// Disables screenshot and blocks app view on Recent Apps
                return SecureApplication(
                  nativeRemoveDelay: 0,
                  child: Builder(
                    builder: (context) {
                      /// Access secureApp provider to control its state
                      final secureAppProvider =
                          SecureApplicationProvider.of(context)!;

                      /// Blocks app view on Recent Apps and prevents screenshot/screen recording
                      secureAppProvider.secure();

                      /// Prevents app from locking if users switches to another app and comes back
                      secureAppProvider.pause();

                      /// Locks app and requires authentication
                      secureAppProvider.lock();

                      return SecureGate(
                        blurr: 20,
                        opacity: 0.6,
                        child: const LockScreen(),
                        lockedBuilder: (context, secureNotifier) {
                          return const LockScreen();
                        },
                      );
                    },
                  ),
                );

              case AuthenticationStatus.disabled:

                /// Enables app security
                /// Disables screenshot and blocks app view on Recent Apps
                return SecureApplication(
                  nativeRemoveDelay: 0,
                  child: Builder(
                    builder: (context) {
                      /// Access secureApp provider to control its state
                      final secureAppProvider =
                          SecureApplicationProvider.of(context)!;
                      secureAppProvider.secure();
                      secureAppProvider.pause();
                      return const HomeScreen();
                    },
                  ),
                );

              case AuthenticationStatus.unavailable:
                return const HomeScreen(
                  key: AuthScreenWidgetKeys.authScreenHomeScreen,
                );
            }

          /// Manages when a user has logged out or no logged in user found.
          case AuthorizationStatus.anonAddyLogin:
            return const AnonAddyLoginScreen(
              key: AuthScreenWidgetKeys.authScreenAnonAddyLoginScreen,
            );

          /// Manages when a user has logged out or no logged in user found.
          case AuthorizationStatus.selfHostedLogin:
            return const SelfHostLoginScreen(
              key: AuthScreenWidgetKeys.authScreenSelfHostedLoginScreen,
            );
        }
      },
      error: (error, _) {
        return ErrorScreen(errorMessage: error.toString());
      },
      loading: () {
        return const LoadingScreen(
          key: AuthScreenWidgetKeys.authScreenLoadingScreen,
        );
      },
    );
  }
}
