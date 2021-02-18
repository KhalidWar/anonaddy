import 'dart:convert';

import 'package:anonaddy/models/username/username_data_model.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class UsernameService {
  final _headers = <String, String>{
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Accept": "application/json",
  };

  Future<UsernameModel> getUsernameData() async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.get(
        Uri.encodeFull('$kBaseURL/$kUsernamesURL'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        print('getUsernameData ${response.statusCode}');
        return UsernameModel.fromJson(jsonDecode(response.body));
      } else {
        print('getUsernameData ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UsernameDataModel> createNewUsername(String username) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kUsernamesURL'),
        headers: _headers,
        body: json.encode({"username": "$username"}),
      );

      if (response.statusCode == 201) {
        print("createNewAlias ${response.statusCode}");
        return UsernameDataModel.fromJson(jsonDecode(response.body));
      } else {
        print("createNewAlias ${response.statusCode}");
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
