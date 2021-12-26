import 'dart:convert';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:http/http.dart' as http;

class SearchService {
  SearchService(this.tokenService);
  final AccessTokenService tokenService;

  /// Fetches matching aliases from API
  Future<List<Alias>> fetchMatchingAliases(
      String searchKeyword, bool includeDeleted) async {
    final accessToken = await tokenService.getAccessToken();
    final instanceURL = await tokenService.getInstanceURL();

    try {
      /// https:/app.anonaddy.com/api/v1/aliases

      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasesURL', {
          'deleted': includeDeleted ? 'with' : null,
          "filter[search]": searchKeyword,
        }),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('_fetchMatchingAliases ${response.statusCode}');
        final decodedData = jsonDecode(response.body)['data'];
        return (decodedData as List).map((alias) {
          return Alias.fromJson(alias);
        }).toList();
      } else {
        print('fetchMatchingAliases ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
