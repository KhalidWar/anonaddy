import 'package:anonaddy/screens/authorization_screen/loading_screen.dart';
import 'package:anonaddy/screens/authorization_screen/lock_screen.dart';
import 'package:anonaddy/screens/home_screen/home_screen.dart';
import 'package:anonaddy/screens/login_screen/anonaddy_login_screen.dart';
import 'package:anonaddy/state_management/authorization/auth_notifier.dart';
import 'package:anonaddy/state_management/authorization/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_application/secure_application.dart';

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({Key? key}) : super(key: key);

  static const routeName = 'authorizationScreen';

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final authState = ref.watch(authStateNotifier);

        switch (authState.authStatus) {
          case AuthStatus.initial:
            return const LoadingScreen();

          case AuthStatus.authorized:

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

                  switch (authState.authLock) {
                    case AuthLock.on:

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

                    case AuthLock.off:
                      return const HomeScreen();
                  }
                },
              ),
            );

          case AuthStatus.unauthorized:
            return const AnonAddyLoginScreen();
        }
      },
    );
  }
}
