import 'package:anonaddy/notifiers/authorization/auth_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({Key? key}) : super(key: key);

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
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
            child: Center(
              child: Text(
                'Logout',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(color: Colors.red),
              ),
            ),
            onPressed: () {
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              child: LottieWidget(
                lottie: LottieImages.biometricAnimation,
                lottieHeight: 600,
                repeat: true,
              ),
            ),
            ElevatedButton(
              child: Center(
                child: Text(
                  'Unlock',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              onPressed: () =>
                  ref.read(authStateNotifier.notifier).authenticate(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
