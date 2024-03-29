import 'package:anonaddy/app.dart';
import 'package:anonaddy/utilities/flutter_secure_storage.dart';
import 'package:anonaddy/utilities/startup_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Keeps SplashScreen on until following methods are completed.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  const secureStorage = FlutterSecureStorage();
  await StartupMethods.initHiveAdapters();
  await StartupMethods.handleAppUpdate(secureStorage);

  /// Removes SplashScreen
  FlutterNativeSplash.remove();

  /// Launches app
  runApp(
    /// Phoenix restarts app upon logout
    Phoenix(
      /// Riverpod base widget to store provider state
      child: ProviderScope(
        overrides: [
          flutterSecureStorage.overrideWithValue(secureStorage),
          // settingsNotifier.overrideWith(
          //   await SettingsNotifier.loadSettingsState(secureStorage),
          // ),
        ],
        child: const App(),
      ),
    ),
  );
}
