import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/screens/search_tab/components/search_history.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_state.dart';
import 'package:anonaddy/state_management/search/search_history_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTab extends StatelessWidget {
  void search(BuildContext context) {
    final aliasTabState = context.read(aliasTabStateNotifier);
    switch (aliasTabState.status) {
      case AliasTabStatus.loading:
        context.read(nicheMethods).showToast(kLoadingText);
        break;
      case AliasTabStatus.loaded:
        final aliases = aliasTabState.aliases!;
        showSearch(
          context: context,
          delegate: SearchService(aliases),
        );
        break;
      case AliasTabStatus.failed:
        context.read(nicheMethods).showToast(kLoadingText);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(size.height * 0.01),
          child: InkWell(
            child: IgnorePointer(
              child: TextFormField(
                decoration: kTextFormFieldDecoration.copyWith(
                  hintText: kSearchFieldHint,
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            onTap: () => search(context),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                kSearchHistory,
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton(
                child: Text('Clear'),
                onPressed: () => context
                    .read(searchHistoryStateNotifier.notifier)
                    .clearSearchHistory(),
              ),
            ],
          ),
        ),
        Divider(height: 0),
        const SearchHistory(),
      ],
    );
  }
}
