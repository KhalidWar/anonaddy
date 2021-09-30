import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/account/account_model.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/state_management/lifecycle/lifecycle_state_manager.dart';
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
    fetchAccount();
  }

  final AccountService accountService;
  final OfflineData offlineData;
  final LifecycleStatus lifecycleStatus;
  // final bool refresh;

  Future<void> fetchAccount() async {
    try {
      if (state.status != AccountStatus.failed) {
        await _loadOfflineData();
      }

      while (lifecycleStatus == LifecycleStatus.foreground) {
        final account = await accountService.getAccountData();
        await _saveOfflineData(account);
        state =
            AccountState(status: AccountStatus.loaded, accountModel: account);
        await Future.delayed(Duration(seconds: 5));
      }
    } on SocketException {
      await _loadOfflineData();
    } catch (error) {
      if (mounted) {
        state = AccountState(
          status: AccountStatus.failed,
          errorMessage: error.toString(),
        );
        await _retryOnError();
      }
    }
  }

  Future _retryOnError() async {
    if (state.status == AccountStatus.failed) {
      await Future.delayed(Duration(seconds: 5));
      await fetchAccount();
    }
  }

  Future<void> _loadOfflineData() async {
    final securedData = await offlineData.readAccountOfflineData();
    if (securedData.isNotEmpty) {
      final data = AccountModel.fromJson(jsonDecode(securedData));
      state = AccountState(status: AccountStatus.loaded, accountModel: data);
    }
  }

  Future<void> _saveOfflineData(AccountModel account) async {
    final encodedData = jsonEncode(account.toJson());
    await offlineData.writeAccountOfflineData(encodedData);
  }
}
