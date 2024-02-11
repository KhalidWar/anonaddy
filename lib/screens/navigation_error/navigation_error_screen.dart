import 'package:anonaddy/features/auth/data/auth_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationErrorScreen extends ConsumerWidget {
  const NavigationErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Error')),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Expanded(
              child: ErrorMessageWidget(
                message: AppStrings.navigationErrorMessage,
              ),
            ),
            Text(
              'If problem persists, please log out, and log back in',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: const Text('logout'),
                onPressed: () {
                  PlatformAware.platformDialog(
                    context: context,
                    child: PlatformAlertDialog(
                      title: 'Logout',
                      content: AppStrings.logOutAlertDialog,
                      method: () async {
                        await ref
                            .read(authStateNotifier.notifier)
                            .logout(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
