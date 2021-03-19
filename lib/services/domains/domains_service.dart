import 'dart:convert';

import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class DomainsService {
  final _accessTokenService = AccessTokenService();

  Future<DomainModel> getAllDomains() async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.get(
        Uri.encodeFull('$kBaseURL/$kDomainsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getAllDomains ${response.statusCode}');
        return DomainModel.fromJson(jsonDecode(response.body));
      } else {
        print('getAllDomains ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
