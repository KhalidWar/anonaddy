import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
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
      persistentFooterButtons: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: PlatformButton(
            key: logoutButton,
            color: Colors.red,
            child: const Text('Logout'),
            onPress: () {
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
            },
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
