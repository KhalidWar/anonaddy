import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../global_providers.dart';

class AppVersion extends ConsumerWidget {
  const AppVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accountState = watch(accountStateNotifier);

    switch (accountState.status) {
      case AccountStatus.loading:
        return Container();

      case AccountStatus.loaded:
        final subscription = accountState.accountModel!.account.subscription;

        if (subscription == null) {
          return Consumer(
            builder: (_, watch, __) {
              final appVersionData = watch(appVersionProvider);
              return appVersionData.when(
                loading: () => Text('...'),
                data: (appData) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('v' + appData.version),
                  );
                },
                error: (error, stackTrace) => Container(),
              );
            },
          );
        }

        return Container();

      case AccountStatus.failed:
        return Container();
    }
  }
}
