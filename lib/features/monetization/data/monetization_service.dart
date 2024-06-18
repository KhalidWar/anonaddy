import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

final monetizationServiceProvider =
    Provider<MonetizationService>((ref) => const MonetizationService());

class MonetizationService {
  const MonetizationService();

  Future<bool> isConfigured() async {
    try {
      return await Purchases.isConfigured;
    } catch (e) {
      return false;
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

  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } on PlatformException catch (_) {
      rethrow;
    }
  }
}
