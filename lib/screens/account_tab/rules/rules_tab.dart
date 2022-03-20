import 'package:anonaddy/models/rules/rules.dart';
import 'package:anonaddy/screens/account_tab/components/paid_feature_wall.dart';
import 'package:anonaddy/screens/account_tab/rules/rules_list_tile.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
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
        if (subscription == AnonAddyString.subscriptionFree) {
          return const PaidFeatureWall();
        }

        final rulesState = ref.watch(rulesTabStateNotifier);
        switch (rulesState.status) {
          case RulesTabStatus.loading:
            return const RecipientsShimmerLoading();

          case RulesTabStatus.loaded:
            final rules = rulesState.rules;
            if (rules == null) {
              return buildEmptyList(
                context,
                AppStrings.enrollRulesBetaTesting,
              );
            }

            if (rules.isEmpty) {
              return buildEmptyList(context, AppStrings.noRulesFound);
            } else {
              return buildRulesList(rules);
            }

          case RulesTabStatus.failed:
            final error = rulesState.errorMessage;
            return LottieWidget(
              lottie: LottieImages.errorCone,
              lottieHeight: MediaQuery.of(context).size.height * 0.2,
              label: error,
            );
        }

      /// When fetching Account data has failed
      case AccountStatus.failed:
        return LottieWidget(
          lottie: LottieImages.errorCone,
          lottieHeight: MediaQuery.of(context).size.height * 0.2,
          label: AppStrings.loadAccountDataFailed,
        );
    }
  }

  Widget buildRulesList(List<Rules> rules) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: rules.length,
      itemBuilder: (context, index) {
        return RulesListTile(
          rule: rules[index],
          onTap: () => NicheMethod.showToast(AppStrings.comingSoon),
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
