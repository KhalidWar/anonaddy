import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/flutter_secure_storage.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountServiceProvider = Provider<AccountService>((ref) {
  return AccountService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorage),
  );
});

class AccountService extends BaseService {
  const AccountService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = DataStorageKeys.accountKey,
  });

  Future<Account> fetchAccount() async {
    try {
      const urlPath = '$kUnEncodedBaseURL/account-details';
      final accountData = await get(urlPath);
      return Account.fromJson(accountData['data']);
    } catch (error) {
      rethrow;
    }
  }

  Future<Account?> loadCachedData() async {
    try {
      final accountData = await loadData();
      if (accountData == null) return null;
      return Account.fromJson(accountData['data']);
    } catch (error) {
      return null;
    }
  }
}
