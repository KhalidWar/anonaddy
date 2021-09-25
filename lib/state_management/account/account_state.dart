import 'package:anonaddy/models/account/account_model.dart';

enum AccountStatus { loading, loaded, failed }

class AccountState {
  const AccountState({
    required this.status,
    this.accountModel,
    this.errorMessage,
  });

  final AccountStatus status;
  final AccountModel? accountModel;
  final String? errorMessage;
}
