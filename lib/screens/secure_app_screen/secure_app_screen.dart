import 'package:anonaddy/screens/login_screen/initial_screen.dart';
import 'package:anonaddy/screens/secure_app_screen/secure_gate_screen.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_application/secure_application.dart';

/// ConsumerWidget is used to update state using ChangeNotifierProvider
class SecureAppScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    /// Use [watch] method to access different providers
    final settings = watch(settingsStateManagerProvider);
    final isBiometricAuth = settings.isBiometricAuth;

    return SecureApplication(
      nativeRemoveDelay: 1000,
      child: Builder(
        builder: (context) {
          /// Access secureApp provider to control its state
          final secureAppProvider = SecureApplicationProvider.of(context);

          secureAppProvider.secure();
          secureAppProvider.pause();

          if (isBiometricAuth) {
            /// .lock() locks app by activating SecureGate and requiring
            /// authentication to access content behind SecureGate.
            secureAppProvider.lock();
            return SecureGateScreen(child: InitialScreen());
          } else {
            return InitialScreen();
          }
        },
      ),
    );
  }
}
