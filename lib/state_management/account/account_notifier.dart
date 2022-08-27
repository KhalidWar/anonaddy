import 'dart:convert';

import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountStateNotifier =
    StateNotifierProvider<AccountNotifier, AccountState>((ref) {
  return AccountNotifier(
    accountService: ref.read(accountServiceProvider),
    offlineData: ref.read(offlineDataProvider),
  );
});

class AccountNotifier extends StateNotifier<AccountState> {
  AccountNotifier({
    required this.accountService,
    required this.offlineData,
    AccountState? initialState,
  }) : super(initialState ?? AccountState.initialState());

  final AccountService accountService;
  final OfflineData offlineData;

  /// Updates UI to the newState
  void _updateState(AccountState newState) {
    if (mounted) {
      state = newState;
      if (state.status == AccountStatus.loaded) _saveState();
    }
  }

  Future<void> fetchAccount() async {
    try {
      _updateState(state.copyWith(status: AccountStatus.loading));

      final account = await accountService.getAccounts();

      /// Construct new state
      final newState =
          state.copyWith(status: AccountStatus.loaded, account: account);

      /// Update UI with the latest state
      _updateState(newState);
    } on DioError catch (dioError) {
      /// on SockException load offline data
      if (dioError.type == DioErrorType.other) {
        /// Loads offline data when there's no internet connection
        await loadState();
      } else {
        _updateState(state.copyWith(
          status: AccountStatus.failed,
          errorMessage: dioError.message,
        ));
      }

      /// Retry after an error
      _retryOnError();
    } catch (error) {
      _updateState(state.copyWith(
        status: AccountStatus.failed,
        errorMessage: AppStrings.somethingWentWrong,
      ));

      /// Retry after an error
      _retryOnError();
    }
  }

  /// Silently fetches the latest account data and displays them
  Future<void> refreshAccount() async {
    try {
      /// Only trigger fetch API when app is Foreground to avoid API spamming
      final account = await accountService.getAccounts();

      /// Update UI with the latest state
      _updateState(state.copyWith(
        status: AccountStatus.loaded,
        account: account,
      ));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }

  /// Triggers [fetchAccount] when it fails after a certain amount of time
  Future _retryOnError() async {
    if (state.isFailed) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchAccount();
    }
  }

  Future<void> _saveState() async {
    try {
      final mappedState = state.toMap();
      final encodedState = json.encode(mappedState);
      await offlineData.saveAccountsState(encodedState);
    } catch (_) {
      return;
    }
  }

  /// Loads [Account] data from disk
  Future<void> loadState() async {
    try {
      final securedData = await offlineData.loadAccountsState();
      if (securedData.isNotEmpty) {
        final decodedData = json.decode(securedData);
        final savedState = AccountState.fromMap(decodedData);
        _updateState(savedState);
      }
    } catch (_) {
      return;
    }
  }
}
