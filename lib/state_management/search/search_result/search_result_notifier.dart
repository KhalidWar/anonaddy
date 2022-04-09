import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/search/search_result/search_result_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchResultStateNotifier =
    StateNotifierProvider<SearchResultNotifier, SearchResultState>((ref) {
  return SearchResultNotifier(
    searchService: ref.read(searchService),
    aliasTabState: ref.read(aliasTabStateNotifier.notifier),
    controller: TextEditingController(),
  );
});

class SearchResultNotifier extends StateNotifier<SearchResultState> {
  SearchResultNotifier({
    required this.searchService,
    required this.aliasTabState,
    required this.controller,
  }) : super(SearchResultState.initial(controller, true));

  final SearchService searchService;
  final AliasTabNotifier aliasTabState;
  final TextEditingController controller;

  /// Updates UI state
  _updateState(SearchResultState newState) {
    if (mounted) state = newState;
  }

  /// Fetches [Alias]es matching [searchKeyword] and sets [SearchResult]
  /// with matching list of aliases
  Future<void> searchAliases() async {
    _updateState(
      state.copyWith(status: SearchResultStatus.loading),
    );

    try {
      /// Extract [searchKeyword] from text controller
      final searchKeyword = state.searchController!.text.trim();

      /// Fetches matching aliases from AnonAddy servers
      final matchingAliases = await searchService.searchAliases(
          searchKeyword, state.includeDeleted!);

      /// Structure new state
      final newState = state.copyWith(
          status: SearchResultStatus.loaded, aliases: matchingAliases);

      /// Trigger a UI update with the new state
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      final newState = state.copyWith(
        status: SearchResultStatus.failed,
        errorMessage: dioError.message,
      );
      _updateState(newState);
    }
  }

  /// Searches through locally available aliases which is 100 aliases after
  /// AnonAddy implemented pagination
  void searchAliasesLocally() {
    final matchingAliases = <Alias>[];

    final text = state.searchController!.text.trim();
    final aliases = aliasTabState.getAliases() ?? [];

    for (var element in aliases) {
      final filterByEmail =
          element.email.toLowerCase().contains(text.toLowerCase());
      if (element.description == null) {
        if (filterByEmail) {
          matchingAliases.add(element);
        }
      } else {
        final filterByDescription =
            element.description!.toLowerCase().contains(text.toLowerCase());

        if (filterByEmail || filterByDescription) {
          matchingAliases.add(element);
        }
      }
    }

    final newState = state.copyWith(
        status: SearchResultStatus.limited, aliases: matchingAliases);
    _updateState(newState);
  }

  /// Controls [showCloseIcon] visibility
  void toggleCloseIcon() {
    if (state.searchController != null) {
      final toggle = state.searchController!.text.isNotEmpty;
      final newState = state.copyWith(showCloseIcon: toggle);
      _updateState(newState);
    }
  }

  /// Controls [SearchResultState.includeDeleted] visibility
  void toggleIncludeDeleted(bool toggle) {
    //todo [toggle] should show/hide deleted aliases from result list
    // final availableAliases = <Alias>[];
    // if (state.status == SearchResultStatus.Loaded) {
    //   state.aliases!.forEach((alias) {
    //     if (alias.deletedAt == null) {
    //       availableAliases.add(alias);
    //     }
    //   });
    //
    //   final aliases = toggle ? state.aliases! : availableAliases;
    //   final newState = state.copyWith(aliases: aliases, includeDeleted: toggle);
    //   _updateState(newState);
    //   return;
    // } else {
    //   final newState = state.copyWith(includeDeleted: toggle);
    //   _updateState(newState);
    // }

    final newState = state.copyWith(includeDeleted: toggle);
    _updateState(newState);
  }

  /// Resets [SearchState] to initial state
  void closeSearch() {
    if (state.searchController != null) {
      state.searchController!.clear();

      _updateState(
        SearchResultState.initial(controller, state.includeDeleted!),
      );
    }
  }
}
