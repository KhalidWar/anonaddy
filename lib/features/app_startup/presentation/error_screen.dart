import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/features/app_startup/presentation/controller/app_startup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorScreen extends ConsumerWidget {
  const ErrorScreen({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  static const logoutButton = Key('error_screen_logout_button');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          AppStrings.appName,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white),
        ),
        actions: [
          TextButton(
            key: logoutButton,
            onPressed: () {
              /// Show platform dialog
              PlatformAware.platformDialog(
                context: context,
                child: PlatformAlertDialog(
                  title: 'Log out',
                  content: AppStrings.logOutAlertDialog,
                  method: ref.read(appStartupProvider.notifier).logout,
                ),
              );
            },
            child: Text(
              'Log out',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: PlatformButton(
            child: Text(
              'Retry',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.black),
            ),
            onPress: () => ref.invalidate(appStartupProvider),
          ),
        ),
      ],
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Text(
          errorMessage,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
