import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_state.dart';
import 'package:anonaddy/features/auth/presentation/error_screen.dart';
import 'package:anonaddy/features/auth/presentation/loading_screen.dart';
import 'package:anonaddy/features/auth/presentation/lock_screen.dart';
import 'package:anonaddy/features/home/presentation/home_screen.dart';
import 'package:anonaddy/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_application/secure_application.dart';

/// This widget manages user authentication and authorization
/// flow for the whole app.
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  static const routeName = 'authorizationScreen';

  /// Authorization Screen
  static const authScreenLoadingScreen = Key('authScreenLoadingScreen');
  static const authScreenHomeScreen = Key('authScreenHomeScreen');
  static const authScreenAnonAddyLoginScreen =
      Key('authScreenAnonAddyLoginScreen');
  static const authScreenSelfHostedLoginScreen =
      Key('authScreenSelfHostedLoginScreen');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watches for [authStateNotifier] changes and
    /// updates UI accordingly.
    final authNotifier = ref.watch(authStateNotifier);

    return authNotifier.when(
      data: (authState) {
        if (!authState.isLoggedIn) {
          return const OnboardingScreen(key: authScreenAnonAddyLoginScreen);
        }

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
            return const HomeScreen(key: authScreenHomeScreen);
        }
      },
      error: (error, _) {
        return ErrorScreen(errorMessage: error.toString());
      },
      loading: () {
        return const LoadingScreen(key: authScreenLoadingScreen);
      },
    );
  }
}
