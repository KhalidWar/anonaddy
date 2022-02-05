import 'package:anonaddy/models/account/account.dart';

enum AccountStatus { loading, loaded, failed }

class AccountState {
  const AccountState({
    required this.status,
    this.account,
    this.errorMessage,
  });

  final AccountStatus status;
  final Account? account;
  final String? errorMessage;

  AccountState copyWith({
    AccountStatus? status,
    Account? account,
    String? errorMessage,
  }) {
    return AccountState(
      status: status ?? this.status,
      account: account ?? this.account,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'AccountState{status: $status, account: $account, errorMessage: $errorMessage}';
  }
}
