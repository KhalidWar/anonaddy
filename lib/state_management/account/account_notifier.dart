import 'dart:convert';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
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
  AccountNotifier({required this.accountService, required this.offlineData})
      : super(AccountState.initialState());

  final AccountService accountService;
  final OfflineData offlineData;

  /// Updates UI to the newState
  void _updateState(AccountState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchAccount() async {
    final newState = state.copyWith(status: AccountStatus.loading);
    _updateState(newState);

    try {
      final account = await accountService.getAccounts();
      await _saveOfflineData(account);

      /// Construct new state
      final newState =
          state.copyWith(status: AccountStatus.loaded, account: account);

      /// Update UI with the latest state
      _updateState(newState);
    } catch (error) {
      final dioError = (error as DioError);

      /// on SockException load offline data
      if (dioError.type == DioErrorType.other) {
        /// Loads offline data when there's no internet connection
        await loadOfflineData();
      } else {
        final newState = state.copyWith(
          status: AccountStatus.failed,
          errorMessage: dioError.message.toString(),
        );
        _updateState(newState);
      }

      /// Retry after facing an error
      _retryOnError();
    }
  }

  /// Silently fetches the latest account data and displays them
  Future<void> refreshAccount() async {
    try {
      /// Only trigger fetch API when app is Foreground to avoid API spamming
      final account = await accountService.getAccounts();
      await _saveOfflineData(account);

      /// Construct new state
      final newState =
          state.copyWith(status: AccountStatus.loaded, account: account);

      /// Update UI with the latest state
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      NicheMethod.showToast(dioError.message.toString());
    }
  }

  /// Triggers [fetchAccount] when it fails after a certain amount of time
  Future _retryOnError() async {
    if (state.status == AccountStatus.failed) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchAccount();
    }
  }

  /// Loads [Account] data from disk
  Future<void> loadOfflineData() async {
    /// Load data from disk if state is NOT showing an error
    if (state.status != AccountStatus.failed) {
      final securedData = await offlineData.readAccountOfflineData();
      if (securedData.isNotEmpty) {
        final account = Account.fromJson(jsonDecode(securedData));
        final newState =
            state.copyWith(status: AccountStatus.loaded, account: account);
        _updateState(newState);
      }
    }
  }

  /// Saves [Account] data to disk
  Future<void> _saveOfflineData(Account account) async {
    /// Convert [Account] data to a String to save
    final encodedData = jsonEncode(account);
    await offlineData.writeAccountOfflineData(encodedData);
  }
}
