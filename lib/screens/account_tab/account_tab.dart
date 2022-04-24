import 'package:anonaddy/screens/account_tab/components/account_tab_header.dart';
import 'package:anonaddy/screens/account_tab/domains/domains_tab.dart';
import 'package:anonaddy/screens/account_tab/recipients/recipients_tab.dart';
import 'package:anonaddy/screens/account_tab/rules/rules_tab.dart';
import 'package:anonaddy/screens/account_tab/usernames/usernames_tab.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/paid_feature_blocker.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountTab extends ConsumerStatefulWidget {
  const AccountTab({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _AccountTabState();
}

class _AccountTabState extends ConsumerState<AccountTab> {
  @override
  void initState() {
    super.initState();

    /// Initially load data from disk (secured device storage)
    ref.read(accountStateNotifier.notifier).loadOfflineData();

    /// Fetch latest data from server
    ref.read(accountStateNotifier.notifier).fetchAccount();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: size.height * 0.3,
                elevation: 0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Consumer(
                    builder: (_, watch, __) {
                      final accountState = ref.watch(accountStateNotifier);
                      switch (accountState.status) {
                        case AccountStatus.loading:
                          return const Center(
                            child: PlatformLoadingIndicator(),
                          );

                        case AccountStatus.loaded:
                          return AccountTabHeader(
                            account: accountState.account,
                            isSelfHosted: accountState.isSelfHosted(),
                          );

                        case AccountStatus.failed:
                          return LottieWidget(
                            showLoading: true,
                            lottie: LottieImages.errorCone,
                            lottieHeight: size.height * 0.2,
                            label: accountState.errorMessage,
                          );
                      }
                    },
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
              DomainsTab(),
              RulesTab(),
            ],
          ),
        ),
      ),
    );
  }
}
