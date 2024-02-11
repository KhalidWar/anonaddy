import 'dart:developer';

import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/services/data_storage/account_data_storage.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/dio_client/dio_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountServiceProvider = Provider<AccountService>((ref) {
  return AccountService(
    dio: ref.read(dioProvider),
    accountDataStorage: ref.read(accountDataStorageProvider),
  );
});

class AccountService {
  const AccountService({
    required this.dio,
    required this.accountDataStorage,
  });
  final Dio dio;
  final AccountDataStorage accountDataStorage;

  Future<Account> fetchAccount() async {
    try {
      const urlPath = '$kUnEncodedBaseURL/account-details';
      final response = await dio.get(urlPath);
      final accountData = response.data['data'];
      accountDataStorage.saveData(accountData);
      final account = Account.fromJson(accountData);
      log('getAccounts: ${response.statusCode}');
      return account;
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.other) {
        final account = await accountDataStorage.loadData();
        if (account != null) return account;
      }
      throw dioError.message;
    } catch (error) {
      throw AppStrings.loadAccountDataFailed;
    }
  }

  Future<Account?> loadAccountFromDisk() async {
    try {
      final account = await accountDataStorage.loadData();
      return account;
    } catch (error) {
      return null;
    }
  }
}
