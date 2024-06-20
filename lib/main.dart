import 'package:anonaddy/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_application/secure_application.dart';

// TODO: Implement SecureApplicationController
// final secureAppController = SecureApplicationController(SecureApplicationState(
//   secured: true,
//   locked: true,
// ));

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Keeps SplashScreen on until following methods are completed.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Removes SplashScreen
  FlutterNativeSplash.remove();

  /// Launches app
  runApp(
    const ProviderScope(
      child: SecureApplication(
        nativeRemoveDelay: 0,
        // secureApplicationController: secureAppController,
        child: App(),
      ),
    ),
  );
}
