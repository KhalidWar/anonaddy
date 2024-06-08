import 'package:anonaddy/app.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/common/startup_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const revenueCatAndroidAPIKey =
    String.fromEnvironment('revenue-cat-android-api-key');
const revenueCatIOSAPIKey = String.fromEnvironment('revenue-cat-ios-api-key');

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Keeps SplashScreen on until following methods are completed.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  const secureStorage = FlutterSecureStorage();
  await StartupMethods.handleAppUpdate(secureStorage);
  await StartupMethods.configureRevenueCat(
    androidApiKey: revenueCatAndroidAPIKey,
    iOSApiKey: revenueCatIOSAPIKey,
  );

  /// Removes SplashScreen
  FlutterNativeSplash.remove();

  /// Launches app
  runApp(
    /// Phoenix restarts app upon logout
    Phoenix(
      /// Riverpod base widget to store provider state
      child: ProviderScope(
        overrides: [
          flutterSecureStorageProvider.overrideWithValue(secureStorage),
          // settingsNotifier.overrideWith(
          //   await SettingsNotifier.loadSettingsState(secureStorage),
          // ),
        ],
        child: const App(),
      ),
    ),
  );
}
