import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/features/auth/presentation/auth_screen.dart';
import 'package:anonaddy/features/settings/presentation/controller/settings_notifier.dart';
import 'package:anonaddy/route_generator.dart';
import 'package:anonaddy/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ConsumerWidget is used to update state using ChangeNotifierProvider
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Use [watch] method to access different providers
    final settingsState = ref.watch(settingsNotifier).value;

    /// Sets StatusBarColor for the whole app
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme:
          settingsState?.isDarkTheme ?? false ? AppTheme.dark : AppTheme.light,
      darkTheme: AppTheme.dark,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: AuthScreen.routeName,
      locale: const Locale('en', 'US'),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
