import 'package:anonaddy/screens/alert_center/components/failed_delivery_list_tile.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/failed_delivery/failed_delivery_notifier.dart';
import 'package:anonaddy/state_management/failed_delivery/failed_delivery_state.dart';
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
    switch (failedDeliveryState.status) {
      case FailedDeliveryStatus.loading:
        return const Center(child: PlatformLoadingIndicator());

      case FailedDeliveryStatus.loaded:
        final deliveries = failedDeliveryState.failedDeliveries;

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
                    onPress: () => ref
                        .read(failedDeliveryStateNotifier.notifier)
                        .deleteFailedDelivery(failedDelivery.id),
                  );
                },
              );

      case FailedDeliveryStatus.failed:
        return LottieWidget(
          lottie: LottieImages.errorCone,
          label: failedDeliveryState.errorMessage,
        );
    }
  }
}
