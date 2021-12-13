import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/state_management/search/search_result/search_result_notifier.dart';
import 'package:anonaddy/state_management/search/search_result/search_result_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTabHeader extends StatelessWidget {
  const SearchTabHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(
          kSearchAliasByEmailOrDesc,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: size.height * 0.01),
        Consumer(
          builder: (context, watch, _) {
            final searchState = watch(searchResultStateNotifier);

            return Column(
              children: [
                TextField(
                  controller: searchState.searchController,
                  textInputAction: TextInputAction.search,
                  // inputFormatters: [TextInputFormatter()],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: kSearchFieldHint,
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: closeIcon(context, searchState),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onTap: () {},
                  onChanged: (input) {
                    context
                        .read(searchResultStateNotifier.notifier)
                        .toggleCloseIcon();
                    context
                        .read(searchResultStateNotifier.notifier)
                        .searchAliasesLocally();
                  },
                  onSubmitted: (keyword) {
                    context
                        .read(searchResultStateNotifier.notifier)
                        .searchAliases();
                  },
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Include deleted aliases',
                      style: TextStyle(color: Colors.white),
                    ),
                    PlatformSwitch(
                      value: searchState.includeDeleted!,
                      onChanged: (toggle) {
                        context
                            .read(searchResultStateNotifier.notifier)
                            .toggleIncludeDeleted(toggle);
                      },
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ],
    );
  }

  Widget? closeIcon(BuildContext context, SearchResultState state) {
    if (state.showCloseIcon ?? false) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              context.read(searchResultStateNotifier.notifier).closeSearch();
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              /// Dismisses keyboard
              FocusScope.of(context).requestFocus(FocusNode());

              /// Triggers search
              context.read(searchResultStateNotifier.notifier).searchAliases();
            },
          ),
        ],
      );
    }
  }
}
