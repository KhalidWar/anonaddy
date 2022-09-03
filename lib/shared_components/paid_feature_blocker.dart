import 'package:anonaddy/screens/account_tab/domains/domains_tab.dart';
import 'package:anonaddy/screens/account_tab/rules/rules_tab.dart';
import 'package:anonaddy/screens/account_tab/usernames/usernames_tab.dart';
import 'package:anonaddy/screens/alert_center/failed_deliveries_widget.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/notifiers/account/account_notifier.dart';
import 'package:anonaddy/notifiers/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This widget watches for [AccountState] and update state accordingly.
/// It controls access to PAID FEATURES that aren't available for free users.
/// If subscription tier is free, block access to feature.
/// If subscription tier is paid, display [child] widget, a paid feature.
///
/// List of paid features:
///   1. Additional Usernames [UsernamesTab]
///   2. Domains [DomainsTab]
///   3. Rules [RulesTab]
///   4. Failed Deliveries [FailedDeliveriesWidget]

class PaidFeatureBlocker extends ConsumerWidget {
  const PaidFeatureBlocker({
    Key? key,
    this.loadingWidget,
    required this.child,
  }) : super(key: key);
  final Widget? loadingWidget;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountStateNotifier);

    switch (accountState.status) {
      case AccountStatus.loading:
        return loadingWidget ?? const RecipientsShimmerLoading();

      case AccountStatus.loaded:
        return accountState.isSubscriptionFree
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  ToastMessage.onlyAvailableToPaid,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            : child;

      case AccountStatus.failed:
        return LottieWidget(
          lottie: LottieImages.errorCone,
          lottieHeight: MediaQuery.of(context).size.height * 0.2,
          label: AppStrings.loadAccountDataFailed,
        );
    }
  }
}
