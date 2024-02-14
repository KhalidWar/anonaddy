import 'dart:async';

import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  static const loadingScreenScaffold = Key('loadingScreenScaffold');
  static const loadingScreenAppLogo = Key('loadingScreenAppLogo');
  static const loadingScreenLoadingIndicator =
      Key('loadingScreenLoadingIndicator');
  static const loadingScreenLogoutButton = Key('loadingScreenLogoutButton');

  @override
  ConsumerState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  static const errorNote =
      'Process is taking longer than usual.\nIf it persists, please log out and login back in.';

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
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/play_store.png',
              key: LoadingScreen.loadingScreenAppLogo,
              height: size.height * 0.3,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: showLogoutButton
                  ? [
                      const PlatformLoadingIndicator(),
                      const SizedBox(height: 10),
                      Text(
                        errorNote,
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10),
                        child: PlatformButton(
                          key: LoadingScreen.loadingScreenLogoutButton,
                          color: Colors.red,
                          child: const Text('Logout'),
                          onPress: () => logout(),
                        ),
                      ),
                    ]
                  : [
                      const PlatformLoadingIndicator(
                        key: LoadingScreen.loadingScreenLoadingIndicator,
                      )
                    ],
            ),
          ),
        ],
      ),
    );
  }

  void logout() {
    /// Show platform dialog
    PlatformAware.platformDialog(
      context: context,
      child: PlatformAlertDialog(
        title: 'Logout',
        content: AppStrings.logOutAlertDialog,
        method: () async {
          await ref.read(authStateNotifier.notifier).logout(context);
        },
      ),
    );
  }
}
