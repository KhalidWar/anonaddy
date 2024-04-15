import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/features/account/data/account_data_storage.dart';
import 'package:anonaddy/features/account/domain/account.dart';
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
      await accountDataStorage.saveData(accountData);
      final account = Account.fromJson(accountData);
      log('fetchAccount: ${response.statusCode}');
      return account;
    } on DioException catch (dioException) {
      if (dioException.type == DioExceptionType.connectionError) {
        final account = await accountDataStorage.loadData();
        if (account != null) return account;
      }
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
