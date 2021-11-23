import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/state_management/authorization/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationErrorScreen extends StatelessWidget {
  const NavigationErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Navigation Error')),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: LottieWidget(
                lottie: 'assets/lottie/errorCone.json',
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
              margin: EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text('logout'),
                onPressed: () => logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future logout(BuildContext context) async {
    /// Show platform dialog
    PlatformAware.platformDialog(
      context: context,
      child: PlatformAlertDialog(
        title: 'Logout',
        content: kLogOutAlertDialog,
        method: () async {
          await context.read(authStateNotifier.notifier).logout(context);
        },
      ),
    );
  }
}
