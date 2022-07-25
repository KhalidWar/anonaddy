import 'dart:async';
import 'dart:convert';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
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
    AliasTabState? initialState,
  }) : super(initialState ?? AliasTabState.initialState());

  final AliasService aliasService;
  final OfflineData offlineData;

  /// Updates UI to the newest state
  void _updateState(AliasTabState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchAvailableAliases() async {
    try {
      _updateState(state.copyWith(status: AliasTabStatus.loading));

      final aliases = await aliasService.getAvailableAliases();

      _updateState(state.copyWith(
        status: AliasTabStatus.loaded,
        availableAliasList: aliases,
      ));
      _saveState();
    } on DioError catch (dioError) {
      /// If offline, load offline data and exit.
      if (dioError.type == DioErrorType.other) {
        await loadState();
      } else {
        _updateState(state.copyWith(
          status: AliasTabStatus.failed,
          errorMessage: dioError.message,
        ));
      }
      await _retryOnError();
    } catch (error) {
      _updateState(state.copyWith(
        status: AliasTabStatus.failed,
        errorMessage: AppStrings.somethingWentWrong,
      ));
      await _retryOnError();
    }
  }

  Future<void> fetchDeletedAliases() async {
    try {
      _updateState(state.copyWith(status: AliasTabStatus.loading));

      final aliases = await aliasService.getDeletedAliases();

      _updateState(state.copyWith(
        status: AliasTabStatus.loaded,
        deletedAliasList: aliases,
      ));
      _saveState();
    } on DioError catch (dioError) {
      /// If offline, load offline data and exit.
      if (dioError.type == DioErrorType.other) {
        await loadState();
      } else {
        _updateState(state.copyWith(
          status: AliasTabStatus.failed,
          errorMessage: dioError.message,
        ));
      }
    } catch (error) {
      _updateState(state.copyWith(
        status: AliasTabStatus.failed,
        errorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }

  /// Silently fetches the latest aliases data and displays them
  Future<void> refreshAliases() async {
    try {
      final availableAliases = await aliasService.getAvailableAliases();
      final deletedAliases = await aliasService.getDeletedAliases();

      _updateState(state.copyWith(
        availableAliasList: availableAliases,
        deletedAliasList: deletedAliases,
      ));
      _saveState();
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }

  Future _retryOnError() async {
    if (state.status == AliasTabStatus.failed) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchAvailableAliases();
      await fetchDeletedAliases();
    }
  }

  /// Fetches aliases from disk and displays them, used at initial app
  /// startup since fetching from disk is a lot faster than fetching from API.
  /// It's also used to when there's no internet connection.
  Future<void> loadState() async {
    try {
      if (state.status != AliasTabStatus.failed) {
        final securedData = await offlineData.loadAliasTabState();
        if (securedData.isNotEmpty) {
          final mappedState = json.decode(securedData);
          final storedState = AliasTabState.fromMap(mappedState);
          _updateState(storedState);
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _saveState() async {
    try {
      final mappedState = state.toMap();
      final encodedData = json.encode(mappedState);
      await offlineData.saveAliasTabState(encodedData);
    } catch (error) {
      rethrow;
    }
  }

  List<Alias> getAliases() {
    if (mounted) {
      return [...state.availableAliasList, ...state.deletedAliasList];
    }
    return <Alias>[];
  }

  /// This function's main use is to improve user experience by
  /// quickly deleting alias from state to emulate responsiveness.
  /// Then, it calls for aliases refresh.
  void deleteAlias(Alias alias) {
    /// Emulates deleted alias by setting its [deletedAt] to non-empty value.
    final updatedAlias = alias.copyWith(deletedAt: '00');

    /// Remove alias from [availableAliasList]
    final availableAliases = state.availableAliasList
      ..removeWhere((listAlias) => listAlias.id == updatedAlias.id);

    _updateState(state.copyWith(availableAliasList: availableAliases));
    refreshAliases();
  }

  /// This function's main use is to improve user experience by
  /// quickly restoring alias to emulate responsiveness.
  /// Then, it calls for aliases refresh.
  void restoreAlias(Alias alias) {
    /// Emulates deleted alias by setting its [deletedAt] to non-empty value.
    final updatedAlias = alias.copyWith(deletedAt: '');

    final deletedAliases = state.deletedAliasList
      ..removeWhere((listAlias) => listAlias.id == updatedAlias.id);

    _updateState(state.copyWith(deletedAliasList: deletedAliases));
    refreshAliases();
  }

  /// Adds specific alias to aliases, mainly used to add newly
  /// created alias to list of available aliases without making an API
  /// request and forcing the user to wait before interacting with the new alias.
  void addAlias(Alias alias) async {
    /// Injects [alias] into the first slot in the list
    final availableAliases = state.availableAliasList..insert(0, alias);

    _updateState(state.copyWith(
      availableAliasList: availableAliases,
    ));
  }
}
