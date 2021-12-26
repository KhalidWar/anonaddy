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

  @override
  String toString() {
    return 'AccountState{status: $status, account: $account, errorMessage: $errorMessage}';
  }
}
