import 'dart:async';
import 'dart:convert';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasTabStateNotifier =
    StateNotifierProvider<AliasTabNotifier, AliasTabState>((ref) {
  return AliasTabNotifier(
    aliasService: ref.read(aliasServiceProvider),
    offlineData: ref.read(offlineDataProvider),
  );
});

class AliasTabNotifier extends StateNotifier<AliasTabState> {
  AliasTabNotifier({
    required this.aliasService,
    required this.offlineData,
  }) : super(AliasTabState.initialState());

  final AliasService aliasService;
  final OfflineData offlineData;

  /// Updates UI to the newest state
  void _updateState(AliasTabState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchAliases() async {
    final newState = state.copyWith(status: AliasTabStatus.loading);
    _updateState(newState);

    try {
      final aliases = await aliasService.getAliases('with');
      await _saveOfflineData(aliases);

      /// Fetches more aliases if there's not enough
      await fetchMoreAliases(aliases);

      final newState = state.copyWith(
        status: AliasTabStatus.loaded,
        aliases: aliases,
        availableAliasList: _getAvailableAliases(aliases),
        deletedAliasList: _getDeletedAliases(aliases),
      );
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;

      /// If offline, load offline data and exit.
      if (dioError.type == DioErrorType.other) {
        await loadOfflineAliases();
      } else {
        final newState = state.copyWith(
          status: AliasTabStatus.failed,
          errorMessage: dioError.message,
        );
        _updateState(newState);
      }

      await _retryOnError();
    }
  }

  /// Silently fetches the latest aliases data and displays them
  Future<void> refreshAliases() async {
    try {
      final aliases = await aliasService.getAliases('with');
      await _saveOfflineData(aliases);

      /// Fetches more aliases if there's not enough
      await fetchMoreAliases(aliases);

      final newState = state.copyWith(
        status: AliasTabStatus.loaded,
        aliases: aliases,
        availableAliasList: _getAvailableAliases(aliases),
        deletedAliasList: _getDeletedAliases(aliases),
      );
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      NicheMethod.showToast(dioError.message);
    }
  }

  Future _retryOnError() async {
    if (state.status == AliasTabStatus.failed) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchAliases();
    }
  }

  /// Fetches more available aliases if there's less than 20
  Future<void> fetchMoreAliases(List<Alias> aliases) async {
    try {
      /// Fetches 100 additional available aliases if there are less than 20
      if (_getAvailableAliases(aliases).length < 20) {
        final moreAliases = await aliasService.getAliases(null);
        aliases.addAll(moreAliases);
      }

      /// Fetches 100 additional deleted aliases if there are less than 10
      if (_getDeletedAliases(aliases).length < 20) {
        final moreAliases = await aliasService.getAliases('only');
        aliases.addAll(moreAliases);
      }
    } catch (error) {
      rethrow;
    }
  }

  /// Fetches aliases from disk and displays them, used at initial app
  /// startup since fetching from disk is a lot faster than fetching from API.
  /// It's also used to when there's no internet connection.
  Future<void> loadOfflineAliases() async {
    if (state.status != AliasTabStatus.failed) {
      List<dynamic> encodedAliases = [];
      final securedData = await offlineData.readAliasOfflineData();
      if (securedData.isNotEmpty) encodedAliases = jsonDecode(securedData);
      final aliases =
          encodedAliases.map((alias) => Alias.fromJson(alias)).toList();

      if (aliases.isNotEmpty) {
        final newState = state.copyWith(
          status: AliasTabStatus.loaded,
          aliases: aliases,
          availableAliasList: _getAvailableAliases(aliases),
          deletedAliasList: _getDeletedAliases(aliases),
        );
        _updateState(newState);
      }
    }
  }

  Future<void> _saveOfflineData(List<Alias> aliases) async {
    final encodedData = jsonEncode(aliases);
    await offlineData.writeAliasOfflineData(encodedData);
  }

  List<Alias>? getAliases() {
    if (mounted) {
      return state.aliases;
    }
    return null;
  }

  /// Adds specific alias to aliases, mainly used to add newly
  /// created alias to list of available aliases without making an API
  /// request and forcing the user to wait before interacting with the new alias.
  void addAlias(Alias alias) async {
    /// Injects [alias] into the first slot in the list
    state.aliases!.insert(0, alias);

    /// Saves current list of aliases into disk
    _saveOfflineData(state.aliases!);

    final newState = state.copyWith(
      aliases: state.aliases!,
      availableAliasList: _getAvailableAliases(state.aliases!),
      deletedAliasList: _getDeletedAliases(state.aliases!),
    );
    _updateState(newState);

    state.availableListKey.currentState!
        .insertItem(0, duration: const Duration(milliseconds: 300));
  }

  /// Moves deleted alias from available to deleted aliases
  void deleteAlias(String aliasId) {
    /// Emulates deleting alias by setting its [deletedAt] to now.
    /// Then add it to aliases so it can show up in deletedAliases.
    final alias = state.aliases!.firstWhere((alias) => alias.id == aliasId);
    alias.deletedAt = DateTime.now();
    state.aliases!.insert(0, alias);

    /// Saves current list of aliases into disk
    _saveOfflineData(state.aliases!);

    final newState = state.copyWith(
      aliases: state.aliases,
      availableAliasList: _getAvailableAliases(state.aliases!),
      deletedAliasList: _getDeletedAliases(state.aliases!),
    );
    _updateState(newState);
  }

  /// Sorts through aliases and returns available aliases
  List<Alias> _getAvailableAliases(List<Alias> aliases) {
    final availableAliasList = <Alias>[];
    for (Alias alias in aliases) {
      if (alias.deletedAt == null) {
        availableAliasList.add(alias);
      }
    }
    return availableAliasList;
  }

  /// Sorts through aliases and returns deleted aliases
  List<Alias> _getDeletedAliases(List<Alias> aliases) {
    final deletedAliasList = <Alias>[];
    for (Alias alias in aliases) {
      if (alias.deletedAt != null) {
        deletedAliasList.add(alias);
      }
    }
    return deletedAliasList;
  }
}
