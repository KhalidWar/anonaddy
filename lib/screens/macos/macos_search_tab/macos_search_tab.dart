import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/route_generator.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_shimmer_loading.dart';
import 'package:anonaddy/screens/macos/components/macos_sidebar_toggle.dart';
import 'package:anonaddy/screens/search_tab/components/search_history.dart';
import 'package:anonaddy/screens/search_tab/components/search_list_header.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/search/search_history/search_history_notifier.dart';
import 'package:anonaddy/state_management/search/search_result/search_result_notifier.dart';
import 'package:anonaddy/state_management/search/search_result/search_result_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosSearchTab extends StatefulWidget {
  const MacosSearchTab({Key? key}) : super(key: key);

  @override
  State<MacosSearchTab> createState() => _MacosSearchTabState();
}

class _MacosSearchTabState extends State<MacosSearchTab> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            title: const Text('Search History'),
            actions: [
              ToolBarIconButton(
                label: 'Test',
                icon: const MacosIcon(CupertinoIcons.add),
                showLabel: false,
                onPressed: () {},
              ),
              MacosSidebarToggle(context),
            ],
          ),
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return Consumer(
                  builder: (context, ref, _) {
                    final searchState = ref.watch(searchResultStateNotifier);

                    switch (searchState.status) {
                      case SearchResultStatus.initial:
                        return Column(
                          children: [
                            SearchListHeader(
                              title: AppStrings.searchHistory,
                              buttonLabel:
                                  AppStrings.clearSearchHistoryButtonText,
                              buttonTextColor: Colors.red,
                              onPress: () {
                                ref
                                    .read(searchHistoryStateNotifier.notifier)
                                    .clearSearchHistory();
                              },
                            ),
                            const SearchHistory(),
                          ],
                        );

                      case SearchResultStatus.limited:
                        final aliases = searchState.aliases!;
                        return buildResult(context, ref, aliases, true);

                      case SearchResultStatus.loading:
                        return Column(
                          children: [
                            SearchListHeader(
                              title: AppStrings.searching,
                              buttonLabel: AppStrings.cancelSearchingButtonText,
                              buttonTextColor: Colors.red,
                              onPress: () {
                                ref
                                    .read(searchResultStateNotifier.notifier)
                                    .closeSearch();
                              },
                            ),
                            const Expanded(child: AliasShimmerLoading()),
                          ],
                        );

                      case SearchResultStatus.loaded:
                        final aliases = searchState.aliases ?? [];
                        return buildResult(context, ref, aliases, false);

                      case SearchResultStatus.failed:
                        final errorMessage = searchState.errorMessage;
                        return LottieWidget(
                          label: errorMessage,
                          lottie: LottieImages.emptyResult,
                          lottieHeight: 150,
                        );
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildResult(BuildContext context, WidgetRef ref,
      List<Alias> resultsList, bool isLimited) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SearchListHeader(
          title: isLimited
              ? AppStrings.limitedSearchResult
              : AppStrings.searchResult,
          buttonLabel: AppStrings.closeSearchButtonText,
          onPress: () {
            // FocusScope.of(context).requestFocus(FocusNode());
            ref.read(searchResultStateNotifier.notifier).closeSearch();
          },
        ),
        if (isLimited)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text('Tap Search for a full search'),
          ),
        if (resultsList.isEmpty && isLimited)
          Container()
        else if (resultsList.isEmpty)
          LottieWidget(
            lottie: LottieImages.emptyResult,
            lottieHeight: size.height * 0.12,
          )
        else
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: resultsList.length,
              itemBuilder: (context, index) {
                final alias = resultsList[index];
                return InkWell(
                  child: IgnorePointer(
                    child: AliasListTile(alias: alias),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    ref
                        .read(searchHistoryStateNotifier.notifier)
                        .addAliasToSearchHistory(alias);

                    Navigator.pushNamed(
                      context,
                      AliasScreen.routeName,
                      arguments: alias,
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
