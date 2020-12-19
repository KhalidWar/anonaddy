import 'dart:convert';

import 'package:anonaddy/models/user/user_model.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../access_token/access_token_service.dart';

class UserService {
  final _headers = <String, String>{
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Accept": "application/json",
  };

  Future<UserModel> getUserData() async {
    final accessToken = await AccessTokenService().getAccessToken();
    _headers["Authorization"] = "Bearer $accessToken";

    final response = await http.get(
        Uri.encodeFull('$kBaseURL/$kAccountDetailsURL'),
        headers: _headers);

    if (response.statusCode == 200) {
      print('getUserData ${response.statusCode}');
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      print('getUserData ${response.statusCode}');
      throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
    }
  }
}
