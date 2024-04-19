import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/features/alert_center/presentation/controller/failed_delivery_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FailedDeliveriesWidget extends ConsumerWidget {
  const FailedDeliveriesWidget({
    super.key,
    required this.failedDeliveryId,
  });

  final String failedDeliveryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failedDeliveryAsync =
        ref.watch(failedDeliveryNotifier(failedDeliveryId));

    return failedDeliveryAsync.when(
      data: (delivery) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                dense: true,
                title: Text(delivery.aliasEmail ?? 'Unknown alias'),
                subtitle: const Text('Alias'),
              ),
              ListTile(
                dense: true,
                title: Text(delivery.recipientEmail ?? 'Unknown recipient'),
                subtitle: const Text('Recipient'),
              ),
              ListTile(
                dense: true,
                title: Text(delivery.bounceType),
                subtitle: const Text('Type'),
              ),
              ListTile(
                dense: true,
                title: Text(delivery.code),
                subtitle: const Text('Code'),
              ),
              ListTile(
                dense: true,
                title: Text(
                  delivery.remoteMta.isEmpty
                      ? 'Not available'
                      : delivery.remoteMta,
                ),
                subtitle: const Text('Remote MTA'),
              ),
              ListTile(
                dense: true,
                title: Text(delivery.createdAt.toString()),
                subtitle: const Text('Created'),
              ),
              SizedBox(
                width: double.infinity,
                child: PlatformButton(
                  color: Colors.red,
                  child: Text(
                    'Delete Failed Delivery',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.black),
                  ),
                  onPress: () async {
                    await ref
                        .read(failedDeliveryNotifier(failedDeliveryId).notifier)
                        .deleteFailedDelivery()
                        .whenComplete(() => Navigator.pop(context));
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (error, _) => ErrorMessageWidget(message: error.toString()),
      loading: () => const SizedBox(
        height: 200,
        width: double.infinity,
        child: PlatformLoadingIndicator(),
      ),
    );
  }
}
