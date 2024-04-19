import 'dart:async';

import 'package:anonaddy/features/alert_center/data/failed_delivery_service.dart';
import 'package:anonaddy/features/alert_center/domain/failed_delivery.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final failedDeliveryNotifier = AsyncNotifierProvider.autoDispose
    .family<FailedDeliveryNotifier, FailedDelivery, String>(
        FailedDeliveryNotifier.new);

class FailedDeliveryNotifier
    extends AutoDisposeFamilyAsyncNotifier<FailedDelivery, String> {
  Future<void> deleteFailedDelivery() async {
    try {
      final id = state.value!.id;
      await ref.read(failedDeliveryService).deleteFailedDelivery(id);
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.current);
    }
  }

  @override
  FutureOr<FailedDelivery> build(String arg) async {
    final service = ref.read(failedDeliveryService);
    return await service.getSpecificFailedDelivery(arg);
  }
}
