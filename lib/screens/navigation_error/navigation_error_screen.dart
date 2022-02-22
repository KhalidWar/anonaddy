import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/state_management/authorization/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationErrorScreen extends ConsumerWidget {
  const NavigationErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Error')),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: LottieWidget(
                lottie: LottieImages.errorCone,
                lottieHeight: size.height * 0.25,
                label: navigationErrorMessage,
              ),
            ),
            Text(
              'If problem persists, please log out, close app, and log back in',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: const Text('logout'),
                onPressed: () => logout(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future logout(BuildContext context, WidgetRef ref) async {
    /// Show platform dialog
    PlatformAware.platformDialog(
      context: context,
      child: PlatformAlertDialog(
        title: 'Logout',
        content: kLogOutAlertDialog,
        method: () async {
          await ref.read(authStateNotifier.notifier).logout(context);
        },
      ),
    );
  }
}
