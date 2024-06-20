import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/features/connectivity/presentation/controller/connectivity_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityNotifierProvider);

    return connectivityAsync.when(
      data: (connectivity) {
        if (connectivity.hasNoConnection) {
          return Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.red,
            child: Text(
              AppStrings.noInternetOfflineData,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        return const SizedBox.shrink();
      },
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
