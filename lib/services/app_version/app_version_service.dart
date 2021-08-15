import 'dart:convert';

import 'package:anonaddy/models/app_version/app_version_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

class AppVersionService {
  final _accessTokenService = AccessTokenService();

  Future<AppVersion> getAppVersionData() async {
    final accessToken = await _accessTokenService.getAccessToken();
    final instanceURL = await _accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAppVersionURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getAppVersionData ${response.statusCode}');
        return AppVersion.fromJson(jsonDecode(response.body));
      } else {
        print('getAppVersionData ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
