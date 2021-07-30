import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/account/account_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

class AccountService {
  final _accessTokenService = AccessTokenService();

  Future<AccountModel> getAccountData(OfflineData offlineData) async {
    final accessToken = await _accessTokenService.getAccessToken();
    final instanceURL = await _accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAccountDetailsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getUserData ${response.statusCode}');
        await offlineData.writeAccountOfflineData(response.body);
        return AccountModel.fromJson(jsonDecode(response.body));
      } else {
        print('getUserData ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } on SocketException {
      final securedData = await offlineData.readAccountOfflineData();
      return AccountModel.fromJson(jsonDecode(securedData));
    } catch (e) {
      throw e;
    }
  }
}
