import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/lottie_images.dart';
import 'package:anonaddy/common/lottie_widget.dart';
import 'package:anonaddy/common/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage(name: 'LockScreenRoute')
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(authNotifierProvider.notifier).authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text(
          AppStrings.appName,
          key: Key('homeScreenAppBarTitle'),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            child: Center(
              child: Text(
                'Logout',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
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
                  method: ref.read(authNotifierProvider.notifier).logout,
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              onPressed: () =>
                  ref.read(authNotifierProvider.notifier).authenticate(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
