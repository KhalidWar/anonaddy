import 'dart:async';

import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/alert_center/data/failed_delivery_service.dart';
import 'package:anonaddy/features/alert_center/domain/failed_delivery.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final failedDeliveriesNotifier = AsyncNotifierProvider.autoDispose<
    FailedDeliveryNotifier, List<FailedDelivery>>(FailedDeliveryNotifier.new);

class FailedDeliveryNotifier
    extends AutoDisposeAsyncNotifier<List<FailedDelivery>> {
  Future<void> getFailedDeliveries() async {
    try {
      final deliveries =
          await ref.read(failedDeliveryService).getFailedDeliveries();
      state = AsyncData(deliveries);
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.current);
    }
  }

  Future<void> deleteFailedDelivery(String id) async {
    try {
      await ref.read(failedDeliveryService).deleteFailedDelivery(id);
      await getFailedDeliveries();
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.current);
    }
  }

  @override
  FutureOr<List<FailedDelivery>> build() async {
    final accountState = ref.watch(accountNotifierProvider).value;
    if (accountState?.isSubscriptionFree ?? true) {
      return [];
    }

    final deliveriesService = ref.read(failedDeliveryService);
    final failedDeliveries = await deliveriesService.getFailedDeliveries();

    return failedDeliveries;
  }
}
