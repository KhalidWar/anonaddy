import 'dart:async';

import 'package:anonaddy/features/monetization/data/monetization_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_ui_flutter/paywall_result.dart';

final monetizationNotifierProvider =
    AsyncNotifierProvider.autoDispose<MonetizationNotifier, bool>(
        MonetizationNotifier.new);

class MonetizationNotifier extends AutoDisposeAsyncNotifier<bool> {
  Future<void> showPaywall() async {
    try {
      final paymentResult =
          await ref.read(monetizationServiceProvider).showPaywall();

      if (paymentResult == PaywallResult.purchased ||
          paymentResult == PaywallResult.restored) {
        state = const AsyncData(false);
        return;
      }
      state = const AsyncData(true);
    } catch (_) {
      state = const AsyncData(true);
    }
  }

  @override
  FutureOr<bool> build() async {
    if (kDebugMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return false;
    }

    final service = ref.read(monetizationServiceProvider);

    /// RevenueCat fails to configure on some devices which causes the app to crash.
    /// This is a workaround to prevent that.
    /// Would rather not show the paywall than crash the app.
    final isConfigured = await service.isConfigured();
    if (!isConfigured) return false;

    final customerInfo = await service.getCustomerInfo();

    if (customerInfo.entitlements.active.isEmpty) {
      return await ref
          .read(monetizationServiceProvider)
          .showPaywall()
          .then((paymentResult) {
        if (paymentResult == PaywallResult.purchased ||
            paymentResult == PaywallResult.restored) {
          return false;
        }
        return true;
      });
    }

    /// Whether to show the paywall or not.
    /// Default is to not show the paywall.
    return false;
  }
}
