import 'dart:convert';

import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

final usernameServiceProvider = Provider((ref) => UsernameService());

class UsernameService {
  final _headers = <String, String>{
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Accept": "application/json",
  };

  Future<UsernameModel> getUsernameData() async {
    final accessToken = await AccessTokenService().getAccessToken();
    _headers["Authorization"] = "Bearer $accessToken";

    final response = await http.get(
      Uri.encodeFull('$kBaseURL/usernames'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = UsernameModel.fromJson(jsonDecode(response.body));
      return data;
    } else {
      return null;
    }
  }
}
