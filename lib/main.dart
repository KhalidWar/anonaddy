import 'package:anonaddy/models/profile/profile.dart';
import 'package:anonaddy/route_generator.dart';
import 'package:anonaddy/screens/authorization_screen/authorization_screen.dart';
import 'package:anonaddy/services/lifecycle_service/lifecycle_service.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/state_management/settings/settings_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/alias/alias.dart';
import 'models/recipient/recipient.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  /// @HiveType(typeId: 0)
  Hive.registerAdapter(AliasAdapter());

  /// @HiveType(typeId: 1)
  Hive.registerAdapter(RecipientAdapter());

  /// @HiveType(typeId: 2)
  Hive.registerAdapter(ProfileAdapter());

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
    final settingsState = watch(settingsStateNotifier);

    /// Sets StatusBarColor for the whole app
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    const _defaultLocalizations = [
      DefaultMaterialLocalizations.delegate,
      DefaultCupertinoLocalizations.delegate,
      DefaultWidgetsLocalizations.delegate,
    ];

    return LifecycleService(
      child: MaterialApp(
        title: kAppBarTitle,
        debugShowCheckedModeBanner: false,
        theme: settingsState.isDarkTheme! ? darkTheme : lightTheme,
        darkTheme: darkTheme,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: AuthorizationScreen.routeName,
        locale: const Locale('en', 'US'),
        localizationsDelegates: _defaultLocalizations,
      ),
    );
  }
}
