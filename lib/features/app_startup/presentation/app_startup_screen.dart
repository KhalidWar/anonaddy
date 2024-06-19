import 'package:anonaddy/app.dart';
import 'package:anonaddy/features/app_startup/presentation/controller/app_startup_provider.dart';
import 'package:anonaddy/features/app_startup/presentation/error_screen.dart';
import 'package:anonaddy/features/app_startup/presentation/loading_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage(name: 'AppStartupScreenRoute')
class AppStartupScreen extends ConsumerWidget {
  const AppStartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartup = ref.watch(appStartupProvider);

    return appStartup.when(
      skipLoadingOnRefresh: false,
      skipLoadingOnReload: false,
      data: (_) => const App(),
      loading: () => const LoadingScreen(),
      error: (error, _) => ErrorScreen(errorMessage: error.toString()),
    );
  }
}
