import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/offline_data/offline_data.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class UsernameService {
  final _accessTokenService = AccessTokenService();

  Future<UsernameModel> getUsernameData(OfflineData offlineData) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.get(
        Uri.encodeFull('$kBaseURL/$kUsernamesURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getUsernameData ${response.statusCode}');
        await offlineData.writeUsernameOfflineData(response.body);
        return UsernameModel.fromJson(jsonDecode(response.body));
      } else {
        print('getUsernameData ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } on SocketException {
      final securedData = await offlineData.readUsernameOfflineData();
      return UsernameModel.fromJson(jsonDecode(securedData));
    } catch (e) {
      throw e;
    }
  }

  Future<UsernameModel> createNewUsername(String username) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kUsernamesURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({"username": "$username"}),
      );

      if (response.statusCode == 201) {
        print("createNewUsername ${response.statusCode}");
        return UsernameModel.fromJson(jsonDecode(response.body));
      } else {
        print("createNewUsername ${response.statusCode}");
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deleteUsername(String usernameID) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.delete(
          Uri.encodeFull('$kBaseURL/$kUsernamesURL/$usernameID'),
          headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken",
          });

      if (response.statusCode == 204) {
        print("deleteUsername ${response.statusCode}");
        return 204;
      } else {
        print("deleteUsername ${response.statusCode}");
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
