import 'dart:async';

import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/features/app_startup/presentation/controller/app_startup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  static const loadingScreenScaffold = Key('loadingScreenScaffold');
  static const loadingScreenAppLogo = Key('loadingScreenAppLogo');
  static const loadingScreenLoadingIndicator =
      Key('loadingScreenLoadingIndicator');
  static const loadingScreenLogoutButton = Key('loadingScreenLogoutButton');

  @override
  ConsumerState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  bool showLogoutButton = false;
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 10), () {
      setState(() {
        showLogoutButton = true;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: LoadingScreen.loadingScreenScaffold,
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: showLogoutButton
            ? [
                TextButton(
                  key: LoadingScreen.loadingScreenLogoutButton,
                  onPressed: ref.read(appStartupProvider.notifier).refresh,
                  child: Text(
                    'Refresh',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ]
            : null,
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: showLogoutButton
                ? [
                    const PlatformLoadingIndicator(color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      'Process is taking longer than usual.\nIf it persists, please refresh.',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ]
                : [
                    const PlatformLoadingIndicator(
                      key: LoadingScreen.loadingScreenLoadingIndicator,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Initializing...',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
          ),
        ),
      ],
      body: Center(
        child: Image.asset(
          'assets/images/play_store.png',
          key: LoadingScreen.loadingScreenAppLogo,
          height: size.height * 0.3,
        ),
      ),
    );
  }
}
