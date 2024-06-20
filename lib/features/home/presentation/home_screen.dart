import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/available_aliases_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/fab_visibility_state.dart';
import 'package:anonaddy/features/connectivity/presentation/controller/connectivity_notifier.dart';
import 'package:anonaddy/features/create_alias/presentation/create_alias.dart';
import 'package:anonaddy/features/home/presentation/components/changelog_widget.dart';
import 'package:anonaddy/features/router/app_router.dart';
import 'package:anonaddy/features/settings/presentation/controller/settings_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_application/secure_application.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@RoutePage(name: 'HomeScreenRoute')
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _switchIndex(TabsRouter tabsRouter, int index) {
    /// Show [FloatingActionButton] when user switches tabs.
    ref.read(fabVisibilityStateNotifier.notifier).showFab();

    /// Tapping on [SearchTab] again navigates to search screen.
    if (tabsRouter.activeIndex == 2 && index == 2) {
      context.pushRoute(const QuickSearchScreenRoute());
    }

    if (index == 0) {
      ref.read(accountNotifierProvider.notifier).fetchAccount();
    }

    if (index == 1) {
      ref.read(availableAliasesNotifierProvider.notifier).fetchAliases();
    }

    tabsRouter.setActiveIndex(index);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(accountNotifierProvider.notifier).fetchAccount();
    });

    /// Show [ChangelogWidget] in [HomeScreen] if app has updated
    ref.read(settingsNotifierProvider.notifier).showChangelogIfAppUpdated();
  }

  @override
  Widget build(BuildContext context) {
    /// Show [ChangelogWidget] if app has been updated
    ref.listen<bool>(
      settingsNotifierProvider
          .select((settingState) => settingState.value?.showChangelog ?? false),
      (_, showChangelog) async {
        if (showChangelog) {
          await WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) {
              return [
                Utilities.buildWoltModalSheetSubPage(
                  context,
                  topBarTitle: 'What\'s new?',
                  child: const ChangelogWidget(),
                ),
              ];
            },
          );
        }
      },
    );

    ref.listen<ConnectivityResult?>(
      connectivityNotifierProvider
          .select((connectivityAsync) => connectivityAsync.value),
      (prev, next) {
        if (prev == null || next == null) return;
        if (prev.hasConnection && next.hasNoConnection) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Center(
                child: Text('No internet connection. Offline mode.'),
              ),
            ),
          );
        }
        if (prev.hasNoConnection && next.hasConnection) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Center(child: Text('Internet connection restored')),
            ),
          );
        }
      },
    );

    return SecureGate(
      // lockedBuilder: (context, controller) {
      //   return Scaffold(
      //     body: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         const Center(
      //           child: CircularProgressIndicator(),
      //         ),
      //         const SizedBox(height: 20),
      //         TextButton(
      //           child: const Text('Unlock'),
      //           onPressed: () {
      //             // secureAppController.pen();
      //           },
      //         ),
      //       ],
      //     ),
      //   );
      // },
      child: AutoTabsRouter(
        routes: const [
          AccountTabRoute(),
          AliasesTabRoute(),
          SearchTabRoute(),
        ],
        transitionBuilder: (_, child, __) {
          return child;
        },
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);

          return Scaffold(
            key: const Key('homeScreenScaffold'),
            floatingActionButton: const CreateAlias(),
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: tabsRouter.activeIndex,
              onTap: (index) => _switchIndex(tabsRouter, index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle_outlined,
                    key: Key('homeScreenBotNavBarFirstIcon'),
                  ),
                  label: AppStrings.accountBotNavLabel,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.alternate_email_outlined,
                    key: Key('homeScreenBotNavBarSecondIcon'),
                  ),
                  label: AppStrings.aliasesBotNavLabel,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search_outlined,
                    key: Key('homeScreenBotNavBarThirdIcon'),
                  ),
                  label: AppStrings.searchBotNavLabel,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
