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
  AccountNotifier({required this.accountService, required this.offlineData})
      : super(AccountState.initialState());

  final AccountService accountService;
  final OfflineData offlineData;

  /// Updates UI to the newState
  void _updateState(AccountState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchAccount() async {
    try {
      _updateState(state.copyWith(status: AccountStatus.loading));

      final account = await accountService.getAccounts();
      await _saveOfflineData(account);

      /// Construct new state
      final newState =
          state.copyWith(status: AccountStatus.loaded, account: account);

      /// Update UI with the latest state
      _updateState(newState);
    } on DioError catch (dioError) {
      /// on SockException load offline data
      if (dioError.type == DioErrorType.other) {
        /// Loads offline data when there's no internet connection
        await loadOfflineData();
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
      await _saveOfflineData(account);

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

  /// Loads [Account] data from disk
  Future<void> loadOfflineData() async {
    /// Load data from disk if state is NOT showing an error
    if (state.isFailed) {
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
