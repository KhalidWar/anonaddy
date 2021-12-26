import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/models/rules/rules.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:http/http.dart' as http;

class RulesService {
  const RulesService(this.accessTokenService);
  final AccessTokenService accessTokenService;

  Future<List<Rules>> getAllRules() async {
    final instanceURL = await accessTokenService.getInstanceURL();
    final accessToken = await accessTokenService.getAccessToken();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kRulesURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getAllRules ${response.statusCode}');
        final decodedData = jsonDecode(response.body)['data'];
        log('decodedData: ' + decodedData.toString());

        return (decodedData as List).map((rule) {
          return Rules.fromJson(rule);
        }).toList();
      } else {
        print('getAllRules ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
