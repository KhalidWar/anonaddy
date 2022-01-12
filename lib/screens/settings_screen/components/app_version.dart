import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
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
        final subscription = accountState.account!.subscription;

        if (subscription == null) {
          return Consumer(
            builder: (_, watch, __) {
              final appVersionData = watch(appVersionProvider);
              return appVersionData.when(
                loading: () => Container(),
                data: (appData) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      'v' + appData.version,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    subtitle: Text('App Version'),
                    trailing: Icon(Icons.info_outlined),
                    onTap: () {
                      NicheMethod.showToast(
                          'App Version number for self-hosted instance');
                    },
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
