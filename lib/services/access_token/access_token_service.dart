import 'dart:io';

import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AccessTokenService {
  final _secureStorage = FlutterSecureStorage();
  final _accessTokenKey = 'accessToken';
  String _accessTokenValue;

  Future validateAccessToken(String accessToken) async {
    try {
      final response = await http.get(
        Uri.https(kAuthorityURL, '$kUnEncodedBaseURL/$kAccountDetailsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      if (response.statusCode == 200) {
        return 200;
      } else {
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } on SocketException {
      throw 'No Internet connection';
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveAccessToken(String value) async {
    await _secureStorage.write(key: _accessTokenKey, value: value);
  }

  Future<String> getAccessToken() async {
    if (_accessTokenValue == null) {
      _accessTokenValue = await _secureStorage.read(key: _accessTokenKey);
      return _accessTokenValue;
    } else {
      return _accessTokenValue;
    }
  }
}
