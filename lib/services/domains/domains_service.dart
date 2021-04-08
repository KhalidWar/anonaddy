import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

class DomainsService {
  final _accessTokenService = AccessTokenService();

  Future<DomainModel> getAllDomains(OfflineData offlineData) async {
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
        await offlineData.writeDomainOfflineData(response.body);
        return DomainModel.fromJson(jsonDecode(response.body));
      } else {
        print('getAllDomains ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } on SocketException {
      final securedData = await offlineData.readDomainOfflineData();
      throw DomainModel.fromJson(jsonDecode(securedData));
    } catch (e) {
      throw e;
    }
  }
}
