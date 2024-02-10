import 'package:anonaddy/services/failed_delivery/failed_delivery_service.dart';
import 'package:anonaddy/state_management/failed_delivery/failed_delivery_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final failedDeliveryStateNotifier =
    StateNotifierProvider<FailedDeliveryNotifier, FailedDeliveryState>((ref) {
  final deliveriesService = ref.read(failedDeliveryService);
  return FailedDeliveryNotifier(deliveriesService: deliveriesService);
});

class FailedDeliveryNotifier extends StateNotifier<FailedDeliveryState> {
  FailedDeliveryNotifier({
    required this.deliveriesService,
  }) : super(FailedDeliveryState.initialState());

  final FailedDeliveryService deliveriesService;

  /// Updates state to the latest state
  void _updateState(FailedDeliveryState newState) {
    if (mounted) state = newState;
  }

  Future<void> getFailedDeliveries() async {
    _updateState(state.copyWith(status: FailedDeliveryStatus.loading));
    try {
      final deliveries = await deliveriesService.getFailedDeliveries();
      final newState = state.copyWith(
        status: FailedDeliveryStatus.loaded,
        failedDeliveries: deliveries,
      );
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      final newState = state.copyWith(
        status: FailedDeliveryStatus.failed,
        errorMessage: dioError.message.toString(),
      );
      _updateState(newState);
    }
  }

  Future<void> deleteFailedDelivery(String id) async {
    try {
      await deliveriesService.deleteFailedDelivery(id);
      await getFailedDeliveries();
    } catch (error) {
      final dioError = error as DioError;
      final newState = state.copyWith(
        status: FailedDeliveryStatus.failed,
        errorMessage: dioError.message.toString(),
      );
      _updateState(newState);
    }
  }
}
