import 'dart:developer';

import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/services/dio_client/dio_client.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';

class AccountService {
  const AccountService(this.dioClient);
  final DioClient dioClient;

  Future<Account> getAccountData() async {
    try {
      const urlPath = '$kUnEncodedBaseURL/$kAccountDetailsURL';
      final response = await dioClient.dio.get(urlPath);
      final account = Account.fromJson(response.data['data']);
      log('getAccountData ${response.statusCode}');

      return account;
    } catch (error) {
      final dioError = error as DioError;
      throw dioError;
    }
  }
}
