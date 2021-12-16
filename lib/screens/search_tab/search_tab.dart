import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_shimmer_loading.dart';
import 'package:anonaddy/screens/search_tab/components/search_history.dart';
import 'package:anonaddy/screens/search_tab/components/search_text_field.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:anonaddy/state_management/search/search_history/search_history_notifier.dart';
import 'package:anonaddy/state_management/search/search_result/search_result_notifier.dart';
import 'package:anonaddy/state_management/search/search_result/search_result_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/search_list_header.dart';

class SearchTab extends StatelessWidget {
  const SearchTab();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverAppBar(
                expandedHeight: size.height * 0.2,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.01),
                    child: SearchTabHeader(),
                  ),
                ),
              ),
            ];
          },
          body: Consumer(
            builder: (context, watch, _) {
              final searchState = watch(searchResultStateNotifier);

              switch (searchState.status) {

                /// When search is NOT triggered, basically the default state for [SearchTab]
                /// In this case, show [SearchHistory].
                case SearchResultStatus.Initial:
                  return Column(
                    children: [
                      SearchListHeader(
                        title: kSearchHistory,
                        buttonLabel: kClearSearchHistoryButtonText,
                        buttonTextColor: Colors.red,
                        onPress: () {
                          context
                              .read(searchHistoryStateNotifier.notifier)
                              .clearSearchHistory();
                        },
                      ),
                      const SearchHistory(),
                    ],
                  );

                /// Displays limited search results based on searching through
                /// locally available aliases, typically page 1 of user's aliases.
                case SearchResultStatus.Limited:
                  final aliases = searchState.aliases!;
                  return buildResult(context, aliases, true);

                /// When search is loading e.g. fetching matching aliases
                case SearchResultStatus.Loading:
                  return Column(
                    children: [
                      SearchListHeader(
                        title: kSearching,
                        buttonLabel: kCancelSearchingButtonText,
                        buttonTextColor: Colors.red,
                        onPress: () {
                          /// Close current on-going search
                          context
                              .read(searchResultStateNotifier.notifier)
                              .closeSearch();
                        },
                      ),
                      const Expanded(child: AliasShimmerLoading()),
                    ],
                  );

                /// When search has finished loading and returns matching aliases
                case SearchResultStatus.Loaded:
                  final aliases = searchState.aliases ?? [];
                  return buildResult(context, aliases, false);

                /// When searching fails and returns an error
                case SearchResultStatus.Failed:
                  return const LottieWidget(
                    lottie: 'assets/lottie/empty.json',
                    lottieHeight: 150,
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildResult(
      BuildContext context, List<Alias> resultsList, bool isLimited) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SearchListHeader(
          title: isLimited ? kLimitedSearchResult : kSearchResult,
          buttonLabel: kCloseSearchButtonText,
          onPress: () {
            FocusScope.of(context).requestFocus(FocusNode());
            context.read(searchResultStateNotifier.notifier).closeSearch();
          },
        ),

        /// Display a banner indicating that current results are from a limited list
        if (isLimited)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text('Tap Search for a full search'),
          ),

        /// Display nothing if result from a limited list is empty
        if (resultsList.isEmpty && isLimited)
          Container()
        else

        /// Show empty lottie if result from full search is empty
        if (resultsList.isEmpty)
          LottieWidget(
            lottie: 'assets/lottie/empty.json',
            lottieHeight: size.height * 0.12,
          )
        else
          Expanded(
            child: PlatformScrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: resultsList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final alias = resultsList[index];
                  return InkWell(
                    child: IgnorePointer(
                      child: AliasListTile(aliasData: alias),
                    ),
                    onTap: () {
                      /// Dismisses keyboard
                      FocusScope.of(context).requestFocus(FocusNode());

                      /// Add selected Alias to Search History
                      context
                          .read(searchHistoryStateNotifier.notifier)
                          .addAliasToSearchHistory(alias);

                      /// Navigate to Alias Screen
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
          ),
      ],
    );
  }
}
