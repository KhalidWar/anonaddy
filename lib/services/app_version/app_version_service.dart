import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/models/app_version/app_version_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:http/http.dart' as http;

class AppVersionService {
  const AppVersionService(this.accessTokenService);
  final AccessTokenService accessTokenService;

  Future<AppVersion> getAppVersionData() async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

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
        log('getAppVersionData ${response.statusCode}');
        return AppVersion.fromJson(jsonDecode(response.body));
      } else {
        log('getAppVersionData ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
