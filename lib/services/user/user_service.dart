import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/user/user_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/offline_data/offline_data.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class UserService {
  final _accessTokenService = AccessTokenService();

  Future<UserModel> getUserData() async {
    final accessToken = await _accessTokenService.getAccessToken();
    final offlineData = OfflineData();

    try {
      final response = await http.get(
        Uri.encodeFull('$kBaseURL/$kAccountDetailsURL'),
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
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        print('getUserData ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } on SocketException {
      final securedData = await offlineData.readAccountOfflineData();
      return UserModel.fromJson(jsonDecode(securedData));
    } catch (e) {
      throw e;
    }
  }
}
