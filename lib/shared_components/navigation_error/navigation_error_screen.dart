import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationErrorScreen extends ConsumerWidget {
  const NavigationErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: PlatformButton(
            color: Colors.red,
            child: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.black),
            ),
            onPress: () async {
              await PlatformAware.platformDialog(
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
      appBar: AppBar(title: const Text('Navigation Error')),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  AppStrings.navigationErrorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Text(
              'If problem persists, please log out, and log back in',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
