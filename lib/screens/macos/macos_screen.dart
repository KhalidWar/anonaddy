import 'package:anonaddy/features/search/data/search_result/search_result_notifier.dart';
import 'package:anonaddy/features/settings/presentation/settings_screen.dart';
import 'package:anonaddy/route_generator.dart';
import 'package:anonaddy/screens/macos/account/macos_account_tab.dart';
import 'package:anonaddy/screens/macos/macos_aliases_tab/macos_aliases_tab.dart';
import 'package:anonaddy/screens/macos/macos_home_screen/macos_home_screen.dart';
import 'package:anonaddy/screens/macos/macos_search_tab/macos_search_tab.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosScreen extends ConsumerStatefulWidget {
  const MacosScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MacHomeScreenState();
}

class _MacHomeScreenState extends ConsumerState<MacosScreen> {
  int pageIndex = 0;

  void changePage(int newIndex) {
    setState(() {
      pageIndex = newIndex;
    });
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(aliasesNotifierProvider.notifier).loadDataFromStorage();
      // ref.read(aliasesNotifierProvider.notifier).fetchAvailableAliases();
      // ref.read(aliasesNotifierProvider.notifier).fetchDeletedAliases();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MacosWindow(
        sidebar: Sidebar(
          minWidth: 300,
          top: MacosSearchField(
            placeholder: AppStrings.searchAliasByEmailOrDesc,
            controller: ref.read(searchResultStateNotifier).searchController,
            onChanged: (input) {
              ref
                  .read(searchResultStateNotifier.notifier)
                  .searchAliasesLocally();
            },
            onTap: () => changePage(3),
          ),
          builder: (context, scrollController) {
            return SidebarItems(
              selectedColor: AppColors.accentColor,
              scrollController: scrollController,
              currentIndex: pageIndex,
              onChanged: changePage,
              items: const [
                SidebarItem(
                  label: Text('Home'),
                  leading: MacosIcon(CupertinoIcons.home),
                ),
                SidebarItem(
                  label: Text('Account'),
                  leading: MacosIcon(CupertinoIcons.profile_circled),
                ),
                SidebarItem(
                  label: Text('Aliases'),
                  leading: MacosIcon(CupertinoIcons.at),
                ),
                SidebarItem(
                  label: Text('Search History'),
                  leading: MacosIcon(CupertinoIcons.search),
                ),
              ],
            );
          },
          bottom: MacosListTile(
            leading: const MacosIcon(CupertinoIcons.settings),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // onClick: () => changePage(4),
            onClick: () {
              Navigator.pushNamed(
                context,
                SettingsScreen.routeName,
              );
            },
          ),
        ),
        child: CupertinoTabView(
          onGenerateRoute: RouteGenerator.generateRoute,
          builder: (context) {
            return IndexedStack(
              index: pageIndex,
              children: [
                const MacosHomeScreen(),
                const MacosAccountTab(),
                const MacosAliasesTab(),
                const MacosSearchTab(),
                MacosScaffold(
                  children: [
                    ContentArea(
                      builder: (context, scrollController) {
                        return const SettingsScreen();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
