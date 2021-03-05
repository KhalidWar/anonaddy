import 'package:anonaddy/screens/login_screen/initial_screen.dart';
import 'package:anonaddy/services/secure_app_service/secure_app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_application/secure_application.dart';

class SecureAppScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final securedApp = watch(secureAppProvider);
    final isAppSecured = securedApp.isAppSecured;

    return SecureApplication(
      nativeRemoveDelay: 1000,
      child: Builder(
        builder: (context) {
          final secureAppProvider = SecureApplicationProvider.of(context);

          if (isAppSecured) {
            secureAppProvider.lock();
            secureAppProvider.secure();
            secureAppProvider.pause();
          } else {
            secureAppProvider.open();
            secureAppProvider.pause();
          }

          return InitialScreen();
        },
      ),
    );
  }
}
