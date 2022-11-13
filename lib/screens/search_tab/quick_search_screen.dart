import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:anonaddy/notifiers/search/search_history/search_history_notifier.dart';
import 'package:anonaddy/notifiers/search/search_result/search_result_notifier.dart';
import 'package:anonaddy/notifiers/search/search_result/search_result_state.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickSearchScreen extends ConsumerStatefulWidget {
  const QuickSearchScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = 'quickSearchScreen';

  @override
  ConsumerState createState() => _QuickSearchScreenState();
}

class _QuickSearchScreenState extends ConsumerState<QuickSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchResultStateNotifier);

    return Scaffold(
      appBar: SearchAppBar(
        leadingOnPress: () {
          ref.read(searchResultStateNotifier.notifier).closeSearch();
          Navigator.pop(context);
        },
        title: TextFormField(
          controller: searchState.searchController,
          autofocus: true,
          validator: (input) => FormValidator.validateSearchField(input!),
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: AppStrings.searchFieldHint,
            hintStyle: const TextStyle(color: Colors.white),
            // enabledBorder: const OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.white),
            // ),
            suffixIcon: closeIcon(context, ref, searchState.showCloseIcon!),
          ),
          onChanged: (input) {
            ref.read(searchResultStateNotifier.notifier).toggleCloseIcon();
            // ref.read(searchResultStateNotifier.notifier).searchAliasesLocally();
            ref.read(searchResultStateNotifier.notifier).searchAliases();
          },
          onFieldSubmitted: (keyword) {
            ref.read(searchResultStateNotifier.notifier).searchAliases();
          },
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final searchState = ref.watch(searchResultStateNotifier);
          final resultsList = searchState.aliases!;

          switch (searchState.status) {
            case SearchResultStatus.initial:
              return Container();
            // return const SearchHistory();

            case SearchResultStatus.loading:
              return const Center(child: PlatformLoadingIndicator());

            case SearchResultStatus.failed:
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: const Text('It is empty out here!'),
              );

            default:
              if (resultsList.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: const Text('Tap Search for a full search'),
                );
              } else {
                return PlatformScrollbar(
                  child: ListView.builder(
                    itemCount: resultsList.length,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final alias = resultsList[index];
                      return InkWell(
                        child: IgnorePointer(
                          child: AliasListTile(alias: alias),
                        ),
                        onTap: () {
                          /// Dismisses keyboard
                          FocusScope.of(context).requestFocus(FocusNode());

                          /// Add selected Alias to Search History
                          ref
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
                );
              }
          }
        },
      ),
    );
  }

  static Widget? closeIcon(
      BuildContext context, WidgetRef ref, bool showCloseIcon) {
    if (showCloseIcon) {
      return IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          ref.read(searchResultStateNotifier.notifier).closeSearch();
        },
      );
    }
    return null;
  }
}

class SearchAppBar extends AppBar {
  SearchAppBar({
    Key? key,
    required this.title,
    required Function() leadingOnPress,
  }) : super(
          key: key,
          title: title,
          leading: IconButton(
            icon: Icon(
              PlatformAware.isIOS() ? CupertinoIcons.back : Icons.arrow_back,
            ),
            color: Colors.white,
            onPressed: leadingOnPress,
          ),
        );

  final Widget title;
}
