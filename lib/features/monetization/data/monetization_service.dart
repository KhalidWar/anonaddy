import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

enum RevenueCatEntitlements {
  monthly('Monthly'),
  yearly('Yearly');

  const RevenueCatEntitlements(this.value);
  final String value;
}

enum RevenueCatProducts {
  iOSMonthly('monthly'),
  iOSAnnually('annually');

  const RevenueCatProducts(this.value);
  final String value;
}

final monetizationServiceProvider = Provider<MonetizationService>((ref) {
  return const MonetizationService();
});

class MonetizationService {
  const MonetizationService();

  Future<PaywallResult> showPaywallIfNeeded(
    String entitlementIdentifier,
  ) async {
    try {
      final paywallResult =
          await RevenueCatUI.presentPaywallIfNeeded(entitlementIdentifier);
      log(paywallResult.toString());
      return paywallResult;
    } catch (e) {
      rethrow;
    }
  }

  Future<PaywallResult> showPaywall({bool showCloseButton = true}) async {
    try {
      final paywallResult = await RevenueCatUI.presentPaywall(
        displayCloseButton: showCloseButton,
      );
      log(paywallResult.toString());
      return paywallResult;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StoreProduct>> getProducts() async {
    try {
      final productIdentifiers =
          RevenueCatProducts.values.map((e) => e.value).toList();
      final products = await Purchases.getProducts(productIdentifiers);
      return products;
    } on PlatformException catch (_) {
      rethrow;
    }
  }

  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } on PlatformException catch (_) {
      rethrow;
    }
  }

  Future<Offerings> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings;
    } on PlatformException catch (_) {
      rethrow;
    }
  }
}
