import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/paid_feature_blocker.dart';
import 'package:anonaddy/features/account/presentation/components/account_tab_header.dart';
import 'package:anonaddy/features/alert_center/presentation/components/alert_center_icon.dart';
import 'package:anonaddy/features/domains/presentation/domains_tab.dart';
import 'package:anonaddy/features/monetization/presentation/monetization_paywall.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_tab.dart';
import 'package:anonaddy/features/router/app_router.dart';
import 'package:anonaddy/features/rules/presentation/rules_tab.dart';
import 'package:anonaddy/features/usernames/presentation/usernames_tab.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage(name: 'AccountTabRoute')
class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  static const accountTabScaffold = Key('accountTabScaffold');
  static const accountTabSliverAppBar = Key('accountTabSliverAppBar');
  static const accountTabHeader = Key('accountTabHeader');

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        RecipientsTabRoute(),
        UsernamesTabRoute(),
        DomainsTabRoute(),
        RulesTabRoute(),
      ],
      builder: (context, child, controller) {
        return Scaffold(
          body: child,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text(
              AppStrings.appName,
              key: Key('homeScreenAppBarTitle'),
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: const AlertCenterIcon(),
            // flexibleSpace: FlexibleSpaceBar(
            //   collapseMode: CollapseMode.pin,
            //   background: Consumer(
            //     builder: (context, ref, child) {
            //       final accountAsync = ref.watch(accountNotifierProvider);
            //
            //       return accountAsync.when(
            //         data: (account) {
            //           return ListTile(
            //             dense: true,
            //             // contentPadding:
            //             //     const EdgeInsets.only(left: 24, right: 24),
            //             leading: CircleAvatar(
            //               maxRadius: 16,
            //               backgroundColor: AppColors.accentColor,
            //               child: Text(
            //                 account.username[0].toUpperCase(),
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .titleLarge
            //                     ?.copyWith(
            //                       fontWeight: FontWeight.bold,
            //                       color: AppColors.primaryColor,
            //                     ),
            //               ),
            //             ),
            //             title: Text(
            //               Utilities.capitalizeFirstLetter(account.username),
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .bodyLarge
            //                   ?.copyWith(color: Colors.white),
            //             ),
            //             subtitle: Text(
            //               Utilities.capitalizeFirstLetter(
            //                 account.isSelfHosted
            //                     ? AppStrings.selfHosted
            //                     : account.subscription,
            //               ),
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .bodyMedium
            //                   ?.copyWith(color: Colors.white),
            //             ),
            //             trailing: const Icon(
            //               Icons.help_outline_outlined,
            //               color: Colors.white,
            //             ),
            //             onTap: () {},
            //           );
            //         },
            //         error: (_, __) {
            //           return const SizedBox();
            //         },
            //         loading: () {
            //           return const SizedBox();
            //         },
            //       );
            //     },
            //   ),
            // ),
            actions: [
              IconButton(
                key: const Key('homeScreenQuickSearchTrailing'),
                tooltip: AppStrings.quickSearch,
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () =>
                    context.pushRoute(const QuickSearchScreenRoute()),
              ),
              IconButton(
                key: const Key('homeScreenAppBarTrailing'),
                tooltip: AppStrings.settings,
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () => context.pushRoute(const SettingsScreenRoute()),
              ),
            ],
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.accentColor,
              controller: controller,
              tabs: const [
                Tab(text: AppStrings.recipients),
                Tab(text: AppStrings.usernames),
                Tab(text: AppStrings.domains),
                Tab(text: AppStrings.rules),
              ],
            ),
          ),
        );
      },
    );

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
