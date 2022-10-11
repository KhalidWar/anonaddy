import 'dart:async';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/notifiers/alias_state/alias_tab_state.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasTabStateNotifier =
    StateNotifierProvider<AliasTabNotifier, AliasTabState>((ref) {
  return AliasTabNotifier(aliasService: ref.read(aliasServiceProvider));
});

class AliasTabNotifier extends StateNotifier<AliasTabState> {
  AliasTabNotifier({
    required this.aliasService,
    AliasTabState? initialState,
  }) : super(initialState ?? AliasTabState.initialState());

  final AliasService aliasService;

  /// Updates UI to the newest state
  void _updateState(AliasTabState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchAvailableAliases() async {
    try {
      _updateState(state.copyWith(status: AliasTabStatus.loading));

      final aliases = await aliasService.fetchAvailableAliases();

      _updateState(state.copyWith(
        status: AliasTabStatus.loaded,
        availableAliasList: aliases,
      ));
    } catch (error) {
      _updateState(state.copyWith(
        status: AliasTabStatus.failed,
        errorMessage: error.toString(),
      ));
      await _retryOnError();
    }
  }

  Future<void> fetchDeletedAliases() async {
    try {
      _updateState(state.copyWith(status: AliasTabStatus.loading));

      final aliases = await aliasService.fetchDeletedAliases();

      _updateState(state.copyWith(
        status: AliasTabStatus.loaded,
        deletedAliasList: aliases,
      ));
    } catch (error) {
      _updateState(state.copyWith(
        status: AliasTabStatus.failed,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Silently fetches the latest aliases data and displays them
  Future<void> refreshAliases() async {
    try {
      final availableAliases = await aliasService.fetchAvailableAliases();
      final deletedAliases = await aliasService.fetchDeletedAliases();

      _updateState(state.copyWith(
        availableAliasList: availableAliases,
        deletedAliasList: deletedAliases,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  /// Initially, get data from disk (secure device storage) and assign it
  Future<void> loadDataFromStorage() async {
    try {
      final availableAliases =
          await aliasService.loadAvailableAliasesFromDisk();
      final deletedAliases = await aliasService.loadDeletedAliasesFromDisk();

      _updateState(state.copyWith(
        status: AliasTabStatus.loaded,
        availableAliasList: availableAliases,
        deletedAliasList: deletedAliases,
      ));
    } catch (_) {
      return;
    }
  }

  Future _retryOnError() async {
    if (state.status == AliasTabStatus.failed) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchAvailableAliases();
      await fetchDeletedAliases();
    }
  }

  List<Alias> getAliases() {
    if (mounted) {
      return [...state.availableAliasList, ...state.deletedAliasList];
    }
    return <Alias>[];
  }

  /// This function's main use is to improve user experience by quickly deleting
  /// a deleted alias from [availableAliasList] to emulate responsiveness.
  /// Then, it calls for aliases refresh.
  void removeDeletedAlias(Alias alias) {
    final availableAliases = [...state.availableAliasList]
      ..removeWhere((listAlias) => listAlias.id == alias.id);

    _updateState(state.copyWith(availableAliasList: availableAliases));
  }

  /// This function's main use is to improve user experience by quickly removing
  /// a restored alias from [deletedAliasList] to emulate responsiveness.
  void removeRestoredAlias(Alias alias) {
    final deletedAliases = [...state.deletedAliasList]
      ..removeWhere((listAlias) => listAlias.id == alias.id);

    _updateState(state.copyWith(deletedAliasList: deletedAliases));
  }

  /// Adds specific alias to aliases, mainly used to add newly
  /// created alias to list of available aliases without making an API
  /// request and forcing the user to wait before interacting with the new alias.
  void addAlias(Alias alias) async {
    /// Populates new list from existing state's availableAliasList.
    /// Then, injects [alias] into the first slot in the list.
    final availableAliases = [...state.availableAliasList]..insert(0, alias);

    _updateState(state.copyWith(availableAliasList: availableAliases));
  }
}
