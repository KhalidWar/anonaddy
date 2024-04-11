import 'dart:async';
import 'dart:developer';

import 'package:anonaddy/features/monetization/data/monetization_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final monetizationNotifierProvider =
    AsyncNotifierProvider.autoDispose<MonetizationNotifier, bool>(
        MonetizationNotifier.new);

class MonetizationNotifier extends AutoDisposeAsyncNotifier<bool> {
  Future<void> showPaywallIfNeeded() async {
    final service = ref.read(monetizationServiceProvider);
    await service.showPaywallIfNeeded('monthly');
  }

  Future<void> showPaywall() async {
    await ref.read(monetizationServiceProvider).showPaywall();
  }

  @override
  FutureOr<bool> build() async {
    final service = ref.read(monetizationServiceProvider);

    final products = await service.getProducts();
    final offerings = await service.getOfferings();
    final customerInfo = await service.getCustomerInfo();

    log('products: $products');
    log('offerings: $offerings');
    log('customerInfo: $customerInfo');

    if (customerInfo.entitlements.active.isEmpty) {
      await showPaywall();
      return true;
    }

    /// Whether to show the paywall or not.
    /// Default is to not show the paywall.
    return false;
  }
}
