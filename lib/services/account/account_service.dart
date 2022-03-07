import 'dart:developer';

import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';

class AccountService {
  const AccountService(this.dio);
  final Dio dio;

  Future<Account> getAccountData() async {
    try {
      const urlPath = '$kUnEncodedBaseURL/$kAccountDetailsURL';
      final response = await dio.get(urlPath);
      final account = Account.fromJson(response.data['data']);
      log('getAccountData ${response.statusCode}');

      return account;
    } catch (error) {
      rethrow;
    }
  }
}
