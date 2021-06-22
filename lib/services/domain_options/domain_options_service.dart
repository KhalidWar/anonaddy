import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

class DomainOptionsService {
  final _accessTokenService = AccessTokenService();

  Future<DomainOptions> getDomainOptions(OfflineData offlineData) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.get(
        Uri.https(kAuthorityURL, '$kUnEncodedBaseURL/$kDomainsOptionsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getDomainOptions ${response.statusCode}');
        await offlineData.writeDomainOptionsOfflineData(response.body);
        return DomainOptions.fromJson(jsonDecode(response.body));
      } else {
        print('getDomainOptions ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } on SocketException {
      final securedData = await offlineData.readDomainOptionsOfflineData();
      return DomainOptions.fromJson(jsonDecode(securedData));
    } catch (e) {
      throw e;
    }
  }
}
