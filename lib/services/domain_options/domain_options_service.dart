import 'dart:convert';

import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class DomainOptionsService {
  final _headers = <String, String>{
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Accept": "application/json",
  };

  Future<DomainOptions> getDomainOptions() async {
    final accessToken = await AccessTokenService().getAccessToken();
    _headers["Authorization"] = "Bearer $accessToken";

    final response = await http.get(
      Uri.encodeFull('$kBaseURL/domain-options'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      print('getDomainOptions ${response.statusCode}');
      return DomainOptions.fromJson(jsonDecode(response.body));
    } else {
      print('getDomainOptions ${response.statusCode}');
      throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
    }
  }
}
