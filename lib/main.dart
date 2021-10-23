import 'package:anonaddy/services/lifecycle_service/lifecycle_service.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'global_providers.dart';
import 'models/alias/alias.dart';
import 'models/recipient/recipient.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AliasAdapter());
  Hive.registerAdapter(RecipientAdapter());

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
    final settingsState = watch(settingsStateManagerProvider);

    /// Sets StatusBarColor for the whole app
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return LifecycleService(
      child: PlatformApp(settingsState: settingsState),
    );
  }
}
