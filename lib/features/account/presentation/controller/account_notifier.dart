import 'dart:async';

import 'package:anonaddy/features/account/data/account_service.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountNotifierProvider =
    AsyncNotifierProvider.autoDispose<AccountNotifier, Account>(
        AccountNotifier.new);

class AccountNotifier extends AutoDisposeAsyncNotifier<Account> {
  Future<void> fetchAccount() async {
    try {
      final accountService = ref.read(accountServiceProvider);
      state = await AsyncValue.guard(() => accountService.fetchAccount());
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Account> build() async {
    final accountService = ref.read(accountServiceProvider);

    final account = await accountService.loadCachedData();
    if (account != null) return account;

    return await accountService.fetchAccount();
  }
}
