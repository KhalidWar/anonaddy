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

final monetizationServiceProvider =
    Provider<MonetizationService>((ref) => const MonetizationService());

class MonetizationService {
  const MonetizationService();

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
