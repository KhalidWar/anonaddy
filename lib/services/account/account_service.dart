import 'dart:developer';

import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/services/dio_client/dio_interceptors.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountServiceProvider = Provider<AccountService>((ref) {
  return AccountService(dio: ref.read(dioProvider));
});

class AccountService {
  const AccountService({required this.dio});
  final Dio dio;

  Future<Account> getAccounts([String? path]) async {
    try {
      const urlPath = '$kUnEncodedBaseURL/account-details';
      final response = await dio.get(path ?? urlPath);
      final account = Account.fromJson(response.data['data']);
      log('getAccounts: ${response.statusCode}');
      return account;
    } catch (error) {
      rethrow;
    }
  }
}
