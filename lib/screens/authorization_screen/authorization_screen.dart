import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/screens/login_screen/anonaddy_login_screen.dart';
import 'package:anonaddy/state_management/authorization/auth_notifier.dart';
import 'package:anonaddy/state_management/authorization/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_application/secure_application.dart';

import 'loading_screen.dart';
import 'lock_screen.dart';

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({Key? key}) : super(key: key);

  static const routeName = 'authorizationScreen';

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final authState = watch(authStateNotifier);

        switch (authState.authStatus) {
          case AuthStatus.initial:
            return LoadingScreen();

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
                        child: LockScreen(),
                        lockedBuilder: (context, secureNotifier) {
                          return LockScreen();
                        },
                      );

                    case AuthLock.off:
                      return HomeScreen();
                  }
                },
              ),
            );

          case AuthStatus.unauthorized:
            return AnonAddyLoginScreen();
        }
      },
    );
  }
}
