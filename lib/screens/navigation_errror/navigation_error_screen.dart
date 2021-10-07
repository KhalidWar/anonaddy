import 'package:animations/animations.dart';
import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
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
    final isIOS = context.read(targetedPlatform).isIOS();
    final dialog = context.read(confirmationDialog);

    Future<void> logout() async {
      await context.read(authStateNotifier.notifier).logout(context);
    }

    showModal(
      context: context,
      builder: (context) {
        return isIOS
            ? dialog.iOSAlertDialog(context, kLogOutAlertDialog, logout)
            : dialog.androidAlertDialog(context, kLogOutAlertDialog, logout);
      },
    );
  }
}
