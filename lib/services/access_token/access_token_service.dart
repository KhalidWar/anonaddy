import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class AccessTokenService {
  final _secureStorage = FlutterSecureStorage();
  final _accessTokenKey = 'accessToken';

  Future<String> validateAccessToken(String accessToken) async {
    final response = await http.get(
      Uri.encodeFull('$kBaseURL/$kAccountDetailsURL'),
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Accept": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    return APIMessageHandler().getStatusCodeMessage(response.statusCode);
  }

  Future<void> saveAccessToken(String value) async {
    await _secureStorage.write(key: _accessTokenKey, value: value);
  }

  Future<String> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }
}
