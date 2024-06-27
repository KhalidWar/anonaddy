import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountServiceProvider = Provider.autoDispose<AccountService>((ref) {
  return AccountService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorageProvider),
  );
});

class AccountService extends BaseService {
  const AccountService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = DataStorageKeys.accountKey,
  });

  Future<Account> fetchAccount() async {
    const urlPath = '$kUnEncodedBaseURL/account-details';
    final accountData = await get(urlPath);
    return Account.fromJson(accountData['data']);
  }

  Future<Account?> loadCachedData() async {
    final accountData = await loadData();
    if (accountData == null) return null;
    return Account.fromJson(accountData['data']);
  }
}
