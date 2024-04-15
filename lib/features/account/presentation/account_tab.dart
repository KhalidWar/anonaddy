import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/paid_feature_blocker.dart';
import 'package:anonaddy/features/account/presentation/components/account_tab_header.dart';
import 'package:anonaddy/features/domains/presentation/domains_tab.dart';
import 'package:anonaddy/features/monetization/presentation/monetization_paywall.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_tab.dart';
import 'package:anonaddy/features/rules/presentation/rules_tab.dart';
import 'package:anonaddy/features/usernames/presentation/usernames_tab.dart';
import 'package:flutter/material.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  static const accountTabScaffold = Key('accountTabScaffold');
  static const accountTabSliverAppBar = Key('accountTabSliverAppBar');
  static const accountTabHeader = Key('accountTabHeader');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: accountTabScaffold,
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                key: accountTabSliverAppBar,
                expandedHeight: size.height * 0.3,
                elevation: 0,
                floating: true,
                pinned: true,
                flexibleSpace: const FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: AccountTabHeader(key: accountTabHeader),
                ),
                bottom: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.accentColor,
                  tabs: [
                    Tab(text: AppStrings.recipients),
                    Tab(text: AppStrings.usernames),
                    Tab(text: AppStrings.domains),
                    Tab(text: AppStrings.rules),
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            physics: ClampingScrollPhysics(),
            children: [
              RecipientsTab(),
              UsernamesTab(),
              PaidFeatureBlocker(child: DomainsTab()),
              PaidFeatureBlocker(
                child: MonetizationPaywall(child: RulesTab()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
