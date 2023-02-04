import 'package:anonaddy/notifiers/failed_delivery/failed_delivery_notifier.dart';
import 'package:anonaddy/screens/alert_center/components/failed_delivery_list_tile.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FailedDeliveriesWidget extends ConsumerStatefulWidget {
  const FailedDeliveriesWidget({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FailedDeliveriesWidgetState();
}

class _FailedDeliveriesWidgetState
    extends ConsumerState<FailedDeliveriesWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(failedDeliveryStateNotifier.notifier).getFailedDeliveries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final failedDeliveryState = ref.watch(failedDeliveryStateNotifier);

    return failedDeliveryState.when(
      data: (deliveries) {
        return deliveries.isEmpty
            ? const Text('No failed deliveries found')
            : ListView.builder(
                shrinkWrap: true,
                itemCount: deliveries.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final failedDelivery = deliveries[index];
                  return FailedDeliveryListTile(
                    delivery: failedDelivery,
                    onPress: () {
                      PlatformAware.platformDialog(
                        context: context,
                        child: PlatformAlertDialog(
                          title: 'Delete Failed Delivery',
                          content:
                              'Are you sure you want to delete failed delivery?',
                          method: () async {
                            await ref
                                .read(failedDeliveryStateNotifier.notifier)
                                .deleteFailedDelivery(failedDelivery.id);

                            /// Dismisses this dialog
                            if (mounted) Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  );
                },
              );
      },
      error: (error, _) {
        return ErrorMessageWidget(message: error.toString());
      },
      loading: () => const Center(child: PlatformLoadingIndicator()),
    );
  }
}
