import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/app_version/presentation/controller/app_version_notifier.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppVersion extends ConsumerWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountNotifierProvider);

    return accountState.when(
      data: (account) {
        if (account.isSelfHosted) {
          return Consumer(
            builder: (_, ref, __) {
              final appVersionData = ref.watch(appVersionProvider);
              return appVersionData.when(
                loading: () => Container(),
                data: (appData) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      'v${appData.version}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: const Text(AppStrings.appVersion),
                    trailing: const Icon(Icons.info_outlined),
                    onTap: () {
                      Utilities.showToast(ToastMessage.appVersionMessage);
                    },
                  );
                },
                error: (error, stackTrace) => Container(),
              );
            },
          );
        }

        return Container();
      },
      error: (err, stack) => Container(),
      loading: () => Container(),
    );
  }
}
