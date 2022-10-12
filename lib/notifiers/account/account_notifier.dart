import 'package:anonaddy/notifiers/account/account_state.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountStateNotifier =
    StateNotifierProvider<AccountNotifier, AccountState>((ref) {
  return AccountNotifier(accountService: ref.read(accountServiceProvider));
});

class AccountNotifier extends StateNotifier<AccountState> {
  AccountNotifier({
    required this.accountService,
    AccountState? initialState,
  }) : super(initialState ?? AccountState.initialState());

  final AccountService accountService;

  /// Updates UI to the newState
  void _updateState(AccountState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchAccount() async {
    try {
      _updateState(state.copyWith(status: AccountStatus.loading));

      final account = await accountService.fetchAccount();

      /// Construct new state
      final newState =
          state.copyWith(status: AccountStatus.loaded, account: account);

      /// Update UI with the latest state
      _updateState(newState);
    } catch (error) {
      _updateState(state.copyWith(
        status: AccountStatus.failed,
        errorMessage: error.toString(),
      ));

      /// Retry after an error
      _retryOnError();
    }
  }

  /// Silently fetches the latest account data and displays them
  Future<void> refreshAccount() async {
    try {
      /// Only trigger fetch API when app is Foreground to avoid API spamming
      final account = await accountService.fetchAccount();

      /// Update UI with the latest state
      _updateState(state.copyWith(
        status: AccountStatus.loaded,
        account: account,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
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
  Future<void> loadAccountFromDisk() async {
    try {
      final account = await accountService.loadAccountFromDisk();
      _updateState(state.copyWith(
        status: AccountStatus.loaded,
        account: account,
      ));
    } catch (_) {
      return;
    }
  }
}
