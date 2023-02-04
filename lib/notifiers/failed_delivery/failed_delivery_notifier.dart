import 'package:anonaddy/models/failed_delivery/failed_delivery.dart';
import 'package:anonaddy/services/failed_delivery/failed_delivery_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final failedDeliveryStateNotifier = StateNotifierProvider.autoDispose<
    FailedDeliveryNotifier, AsyncValue<List<FailedDelivery>>>((ref) {
  final deliveriesService = ref.read(failedDeliveryService);
  return FailedDeliveryNotifier(deliveriesService: deliveriesService);
});

class FailedDeliveryNotifier
    extends StateNotifier<AsyncValue<List<FailedDelivery>>> {
  FailedDeliveryNotifier({
    required this.deliveriesService,
  }) : super(const AsyncData(<FailedDelivery>[]));

  final FailedDeliveryService deliveriesService;

  Future<void> getFailedDeliveries() async {
    try {
      final deliveries = await deliveriesService.getFailedDeliveries();
      state = AsyncData(deliveries);
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.current);
    }
  }

  Future<void> deleteFailedDelivery(String id) async {
    try {
      await deliveriesService.deleteFailedDelivery(id);
      await getFailedDeliveries();
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.current);
    }
  }
}
