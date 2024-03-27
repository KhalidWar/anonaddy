import 'package:anonaddy/features/settings/presentation/controller/settings_notifier.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/utilities/package_info_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangelogWidget extends ConsumerWidget {
  const ChangelogWidget({Key? key}) : super(key: key);

  /// header('Fixed', Colors.blue),
  /// header('Added', Colors.green),
  /// header('Removed', Colors.red),
  /// header('Improved', Colors.orange),
  Widget header(BuildContext context, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
      ),
    );
  }

  Widget label(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(
            builder: (context, ref, __) {
              final appInfo = ref.watch(packageInfoProvider);
              return appInfo.when(
                data: (data) =>
                    Center(child: Text('App version: ${data.version}')),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
          header(context, 'Added', Colors.green),
          label(context, '1. Matching Addy.io rebrand'),
          header(context, 'Fixed', Colors.blue),
          label(context, '1. Minor functionality bugs.'),
          label(context, '2. Several UI bugs.'),
          label(context, '3. Several flow bugs.'),
          header(context, 'Improved', Colors.orange),
          label(context, '1. Overhauled Create New Alias'),
          label(context, '2. Several bug fixes'),
          label(context, '3. Several under the hood improvements'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PlatformButton(
              onPress: () {
                ref.read(settingsNotifier.notifier).dismissChangelog();
                Navigator.pop(context);
              },
              child: Text(
                'Dismiss',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
