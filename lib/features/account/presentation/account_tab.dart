import 'package:anonaddy/features/domains/presentation/domains_tab.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_tab.dart';
import 'package:anonaddy/features/rules/presentation/rules_tab.dart';
import 'package:anonaddy/features/usernames/presentation/usernames_tab.dart';
import 'package:anonaddy/screens/account_tab/components/account_tab_header.dart';
import 'package:anonaddy/screens/account_tab/components/account_tab_widget_keys.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/paid_feature_blocker.dart';
import 'package:flutter/material.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: AccountTabWidgetKeys.accountTabScaffold,
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                key: AccountTabWidgetKeys.accountTabSliverAppBar,
                expandedHeight: size.height * 0.3,
                elevation: 0,
                floating: true,
                pinned: true,
                flexibleSpace: const FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: AccountTabHeader(
                    key: AccountTabWidgetKeys.accountTabHeader,
                  ),
                ),
                bottom: const TabBar(
                  isScrollable: true,
                  physics: ClampingScrollPhysics(),
                  indicatorColor: AppColors.accentColor,
                  tabs: [
                    Tab(child: Text(AppStrings.recipients)),
                    Tab(child: Text(AppStrings.usernames)),
                    Tab(child: Text(AppStrings.domains)),
                    Tab(child: Text(AppStrings.rules)),
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            physics: ClampingScrollPhysics(),
            children: [
              RecipientsTab(),
              PaidFeatureBlocker(child: UsernamesTab()),
              PaidFeatureBlocker(child: DomainsTab()),
              PaidFeatureBlocker(child: RulesTab()),
            ],
          ),
        ),
      ),
    );
  }
}
