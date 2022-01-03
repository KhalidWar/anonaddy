import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/state_management/lifecycle/lifecycle_state_manager.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'account_state.dart';

final accountStateNotifier =
    StateNotifierProvider<AccountNotifier, AccountState>((ref) {
  return AccountNotifier(
    accountService: ref.read(accountService),
    offlineData: ref.read(offlineDataProvider),
    lifecycleStatus: ref.watch(lifecycleStateNotifier),
  );
});

class AccountNotifier extends StateNotifier<AccountState> {
  AccountNotifier(
      {required this.accountService,
      required this.offlineData,
      required this.lifecycleStatus})
      : super(AccountState(status: AccountStatus.loading)) {
    /// Initially load data from disk (secured device storage)
    _loadOfflineData();

    /// Fetch latest data from server
    fetchAccount();
  }

  final AccountService accountService;
  final OfflineData offlineData;
  final LifecycleStatus lifecycleStatus;

  /// Updates UI to the newState
  void _updateState(AccountState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchAccount() async {
    try {
      /// Only trigger fetch API when app is Foreground to avoid API spamming
      while (lifecycleStatus == LifecycleStatus.foreground) {
        final account = await accountService.getAccountData();
        await _saveOfflineData(account);

        /// Construct new state
        final newState =
            AccountState(status: AccountStatus.loaded, account: account);

        /// Update UI with the latest state
        _updateState(newState);

        /// To avoid spamming API, wait set amount of time before calling API again
        await Future.delayed(Duration(seconds: 5));
      }
    } on SocketException {
      /// Loads offline data when there's no internet connection
      await _loadOfflineData();
    } catch (error) {
      /// On error, update UI state with the error message
      final newState = AccountState(
          status: AccountStatus.failed, errorMessage: error.toString());
      _updateState(newState);

      /// Retry after facing an error
      await _retryOnError();
    }
  }

  /// Silently fetches the latest account data and displays them
  Future<void> refreshAccount() async {
    try {
      /// Only trigger fetch API when app is Foreground to avoid API spamming
      final account = await accountService.getAccountData();
      await _saveOfflineData(account);

      /// Construct new state
      final newState =
          AccountState(status: AccountStatus.loaded, account: account);

      /// Update UI with the latest state
      _updateState(newState);
    } catch (error) {
      NicheMethod.showToast(error.toString());
    }
  }

  /// Triggers [fetchAccount] when it fails after a certain amount of time
  Future _retryOnError() async {
    if (state.status == AccountStatus.failed) {
      await Future.delayed(Duration(seconds: 5));
      await fetchAccount();
    }
  }

  /// Loads [Account] data from disk
  Future<void> _loadOfflineData() async {
    /// Load data from disk if state is NOT showing an error
    if (state.status != AccountStatus.failed) {
      final securedData = await offlineData.readAccountOfflineData();
      if (securedData.isNotEmpty) {
        final account = Account.fromJson(jsonDecode(securedData));
        final newState =
            AccountState(status: AccountStatus.loaded, account: account);
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
