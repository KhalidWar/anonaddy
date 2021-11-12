import 'dart:developer';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/search/search_result/search_result_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchResultStateNotifier =
    StateNotifierProvider<SearchResultNotifier, SearchResultState>((ref) {
  final aliasState = ref.watch(aliasTabStateNotifier);
  return SearchResultNotifier(searchAliases: aliasState.aliases!);
});

class SearchResultNotifier extends StateNotifier<SearchResultState> {
  SearchResultNotifier({required this.searchAliases})
      : super(SearchResultState.initial());

  final List<Alias> searchAliases;

  void search(String input) {
    log('search input:' + input);
    if (input.isEmpty) {
      final newState = state.copyWith(isSearching: true, aliases: []);
      _updateState(newState);
    } else {
      state.aliases = _filterAliases(input);
      final newState =
          state.copyWith(isSearching: true, aliases: state.aliases);
      _updateState(newState);
    }
  }

  List<Alias> _filterAliases(String input) {
    final result = <Alias>[];

    searchAliases.forEach((element) {
      final filterByEmail =
          element.email.toLowerCase().contains(input.toLowerCase());

      if (element.description == null) {
        if (filterByEmail) {
          result.add(element);
        } else {
          result.remove(element);
        }
      } else {
        final filterByDescription =
            element.description!.toLowerCase().contains(input.toLowerCase());

        if (filterByEmail || filterByDescription) {
          result.add(element);
        } else {
          result.remove(element);
        }
      }
    });

    return result;
  }

  void _updateState(SearchResultState newState) {
    state = newState;
  }
}
