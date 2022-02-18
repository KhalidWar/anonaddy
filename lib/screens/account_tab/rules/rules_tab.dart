import 'package:anonaddy/models/rules/rules.dart';
import 'package:anonaddy/screens/account_tab/components/paid_feature_wall.dart';
import 'package:anonaddy/screens/account_tab/rules/rules_list_tile.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/state_management/rules/rules_tab_notifier.dart';
import 'package:anonaddy/state_management/rules/rules_tab_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RulesTab extends ConsumerWidget {
  const RulesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountStateNotifier);

    switch (accountState.status) {

      /// When Account data is loading
      case AccountStatus.loading:
        return const RecipientsShimmerLoading();

      /// When Account data is available
      case AccountStatus.loaded:

        /// [Rules] is a paid feature.
        /// Show paywall if user's account is free tier.
        final subscription = accountState.account!.subscription;
        if (subscription == kFreeSubscription) return const PaidFeatureWall();

        final rulesState = ref.watch(rulesTabStateNotifier);
        switch (rulesState.status) {
          case RulesTabStatus.loading:
            return const RecipientsShimmerLoading();

          case RulesTabStatus.loaded:
            final rules = rulesState.rules;
            if (rules == null) {
              return buildEmptyList(context, 'Enroll in Rules BETA testing');
            }

            if (rules.isEmpty) {
              return buildEmptyList(context, 'No rules found');
            } else {
              return buildRulesList(rules);
            }

          case RulesTabStatus.failed:
            final error = rulesState.errorMessage;
            return LottieWidget(
              lottie: 'assets/lottie/errorCone.json',
              lottieHeight: MediaQuery.of(context).size.height * 0.2,
              label: error,
            );
        }

      /// When fetching Account data has failed
      case AccountStatus.failed:
        return LottieWidget(
          lottie: 'assets/lottie/errorCone.json',
          lottieHeight: MediaQuery.of(context).size.height * 0.2,
          label: kLoadAccountDataFailed,
        );
    }
  }

  Widget buildRulesList(List<Rules> rules) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final rule = rules[index];
        const message = 'Coming soon';
        return RulesListTile(
          rule: rule,
          onTap: () => NicheMethod.showToast(message),
        );
      },
    );
  }

  Widget buildEmptyList(BuildContext context, String label) {
    return Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
