import 'package:anonaddy/screens/account_tab/recipients/recipients_tab.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/account_tab_header.dart';
import 'domains/domains_tab.dart';
import 'rules/rules_tab.dart';
import 'usernames/usernames_tab.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: size.height * 0.34,
                elevation: 0,
                floating: true,
                pinned: true,
                backgroundColor: isDark ? Colors.black : Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Consumer(
                    builder: (_, watch, __) {
                      final accountState = watch(accountStateNotifier);
                      switch (accountState.status) {
                        case AccountStatus.loading:
                          return Center(child: PlatformLoadingIndicator());

                        case AccountStatus.loaded:
                          final account = accountState.account;
                          return AccountTabHeader(account: account!);

                        case AccountStatus.failed:
                          final error = accountState.errorMessage;
                          return LottieWidget(
                            showLoading: true,
                            lottie: 'assets/lottie/errorCone.json',
                            lottieHeight: size.height * 0.2,
                            label: error.toString(),
                          );
                      }
                    },
                  ),
                ),
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: kAccentColor,
                  labelColor: isDark ? Colors.white : Colors.black,
                  tabs: [
                    Tab(child: Text('Recipients')),
                    Tab(child: Text('Usernames')),
                    Tab(child: Text('Domains')),
                    Tab(child: Text('Rules')),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              RecipientsTab(),
              UsernamesTab(),
              DomainsTab(),
              RulesTab()
            ],
          ),
        ),
      ),
    );
  }
}
