import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/state_management/authorization/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(authStateNotifier.notifier).authenticate();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: LottieWidget(
                lottie: 'assets/lottie/biometric.json',
                repeat: true,
              ),
            ),
            unlockButton(context),
            SizedBox(height: size.height * 0.01),
            logoutButton(context),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }

  Widget unlockButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(),
      child: Container(
        height: 40,
        child: Center(
          child: Text(
            'Unlock',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      onPressed: () => ref.read(authStateNotifier.notifier).authenticate(),
    );
  }

  Widget logoutButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.red),
      child: Container(
        height: 40,
        child: Center(
          child: Text(
            'Logout',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      onPressed: () {
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
      },
    );
  }
}
