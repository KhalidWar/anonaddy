import 'package:anonaddy/models/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'models/alias/alias.dart';
import 'models/recipient/recipient.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.removeAfter((BuildContext context) async {
    await Hive.initFlutter();

    /// @HiveType(typeId: 0)
    Hive.registerAdapter(AliasAdapter());

    /// @HiveType(typeId: 1)
    Hive.registerAdapter(RecipientAdapter());

    /// @HiveType(typeId: 2)
    Hive.registerAdapter(ProfileAdapter());
  });

  runApp(
    /// Phoenix restarts app upon logout
    Phoenix(
      /// Riverpod base widget to store provider state
      child: ProviderScope(
        child: App(),
      ),
    ),
  );
}
