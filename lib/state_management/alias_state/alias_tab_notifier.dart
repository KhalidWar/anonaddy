import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';
import 'alias_tab_state.dart';

final aliasTabStateNotifier =
    StateNotifierProvider<AliasTabNotifier, AliasTabState>((ref) {
  return AliasTabNotifier(
    aliasService: ref.read(aliasService),
    offlineData: ref.read(offlineDataProvider),
  );
});

class AliasTabNotifier extends StateNotifier<AliasTabState> {
  AliasTabNotifier({
    required this.aliasService,
    required this.offlineData,
  }) : super(AliasTabState.initialState()) {
    /// Initially, get data from disk (secure device storage) and assign it
    _setOfflineState();

    /// Fetch the latest Aliases data from server
    fetchAliases();
  }

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
      final aliases = await aliasService.getAllAliasesData('with');
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
    } on SocketException {
      _setOfflineState();
    } catch (error) {
      final newState = state.copyWith(
        status: AliasTabStatus.failed,
        errorMessage: error.toString(),
      );
      _updateState(newState);

      await _retryOnError();
    }
  }

  /// Silently fetches the latest aliases data and displays them
  Future<void> refreshAliases() async {
    try {
      final aliases = await aliasService.getAllAliasesData('with');
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
      NicheMethod.showToast(error.toString());
    }
  }

  Future _retryOnError() async {
    if (state.status == AliasTabStatus.failed) {
      await Future.delayed(Duration(seconds: 5));
      await fetchAliases();
    }
  }

  /// Fetches more available aliases if there's less than 20
  Future<void> fetchMoreAliases(List<Alias> aliases) async {
    /// Fetches 100 additional available aliases if there are less than 20
    if (_getAvailableAliases(aliases).length < 20) {
      final moreAliases = await aliasService.getAllAliasesData(null);
      aliases.addAll(moreAliases);
    }

    /// Fetches 100 additional deleted aliases if there are less than 10
    if (_getDeletedAliases(aliases).length < 10) {
      final moreAliases = await aliasService.getAllAliasesData('only');
      aliases.addAll(moreAliases);
    }
  }

  /// Fetches aliases from disk and displays them, used at initial app
  /// startup since fetching from disk is a lot faster than fetching from API.
  /// It's also used to when there's no internet connection.
  Future<void> _setOfflineState() async {
    if (state.status != AliasTabStatus.failed) {
      final savedAliases = await _loadOfflineData();
      if (savedAliases.isNotEmpty) {
        final newState = state.copyWith(
          status: AliasTabStatus.loaded,
          aliases: savedAliases,
          availableAliasList: _getAvailableAliases(savedAliases),
          deletedAliasList: _getDeletedAliases(savedAliases),
        );
        _updateState(newState);
      }
    }
  }

  Future<List<Alias>> _loadOfflineData() async {
    List<dynamic> decodedData = [];
    final securedData = await offlineData.readAliasOfflineData();
    if (securedData.isNotEmpty) decodedData = jsonDecode(securedData);

    if (decodedData.isNotEmpty) {
      final aliases = decodedData.map((alias) {
        return Alias.fromJson(alias);
      }).toList();
      return aliases;
    } else {
      return [];
    }
  }

  Future<void> _saveOfflineData(List<Alias> aliases) async {
    final encodedData = jsonEncode(aliases);
    await offlineData.writeAliasOfflineData(encodedData);
  }

  List<Alias>? getAliases() {
    if (mounted) return state.aliases;
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
