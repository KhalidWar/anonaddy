import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/notifiers/account/account_notifier.dart';
import 'package:anonaddy/notifiers/app_version/app_version_notifier.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppVersion extends ConsumerWidget {
  const AppVersion({Key? key}) : super(key: key);

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
                      style: Theme.of(context).textTheme.bodyText1,
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
