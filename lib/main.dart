import 'dart:convert';

import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/screens/secure_app_screen/secure_app_screen.dart';
import 'package:anonaddy/services/lifecycle_service/lifecycle_service.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'shared_components/constants/hive_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AliasDataModelAdapter());
  Hive.registerAdapter(RecipientDataModelAdapter());

  final secureStorage = const FlutterSecureStorage();

  final containsEncryptionKey =
      await secureStorage.containsKey(key: kHiveSecureKey);
  if (!containsEncryptionKey) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(key: kHiveSecureKey, value: base64UrlEncode(key));
  }

  final data = await secureStorage.read(key: kHiveSecureKey);
  final encryptionKey = base64Url.decode(data!);
  await Hive.openBox<AliasDataModel>(
    kSearchHistoryBox,
    encryptionCipher: HiveAesCipher(encryptionKey),
  );

  runApp(
    /// Phoenix restarts app upon logout
    Phoenix(
      /// Riverpod base widget to store provider state
      child: ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

/// ConsumerWidget is used to update state using ChangeNotifierProvider
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    /// Use [watch] method to access different providers
    final themeProvider = watch(settingsStateManagerProvider);

    /// Sets StatusBarColor for the whole app
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return LifecycleService(
      child: MaterialApp(
        title: 'AddyManager',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.isDarkTheme ? darkTheme : lightTheme,
        darkTheme: darkTheme,
        home: SecureAppScreen(),
      ),
    );
  }
}
