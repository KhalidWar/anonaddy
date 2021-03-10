import 'package:anonaddy/screens/login_screen/initial_screen.dart';
import 'package:anonaddy/services/secure_app_service/secure_app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_application/secure_application.dart';

/// ConsumerWidget is used to update state using ChangeNotifierProvider
class SecureAppScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    /// Use [watch] method to access different providers
    final securedApp = watch(secureAppProvider);
    final isAppSecured = securedApp.isAppSecured;

    return SecureApplication(
      nativeRemoveDelay: 1000,
      child: Builder(
        builder: (context) {
          /// Access SecureApplication provider to control secure app state
          final secureAppProvider = SecureApplicationProvider.of(context);

          if (isAppSecured) {
            /// Lock app by activating SecureGate and requiring authentication to
            /// access content behind SecureGate.
            secureAppProvider.lock();

            /// Secure = prevent screenshot and block app switcher view
            /// Does NOT lock app or requires authentication
            secureAppProvider.secure();
            secureAppProvider.pause();
          } else {
            /// Disables SecureApp and screenshots are permitted
            secureAppProvider.open();
            secureAppProvider.pause();
          }

          return InitialScreen();
        },
      ),
    );
  }
}
