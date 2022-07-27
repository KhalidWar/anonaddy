import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

final testAccountStateNotifier =
    StateNotifierProvider<AccountNotifier, AccountState>((ref) {
  // return _MockAccountNotifier();

  return AccountNotifier(
    accountService: _MockAccountService(),
    offlineData: _MockOfflineData(),
  );
});

class _MockAccountNotifier extends Mock implements AccountNotifier {
  _MockAccountNotifier() : super();

  @override
  AccountState get state => AccountState.initialState();

  @override
  Future<void> loadOfflineData() async {}

  @override
  Future<void> fetchAccount() async {}

  @override
  Future<void> saveOfflineData(Account account) async {}
}

class _MockAccountService extends Mock implements AccountService {
  @override
  Future<Account> getAccounts([String? path]) async {
    return Account();
  }
}

class _MockOfflineData extends Mock implements OfflineData {
  @override
  Future<String> readAccountOfflineData() async => '';

  @override
  Future<void> writeAccountOfflineData(String data) async {}
}
