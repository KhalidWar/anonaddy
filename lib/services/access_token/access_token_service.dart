import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AccessTokenService {
  AccessTokenService(this.secureStorage);
  final FlutterSecureStorage secureStorage;

  static const _accessTokenKey = 'accessToken';
  static const _instanceURLKey = 'instanceURLKey';
  String _accessTokenValue = '';
  String _instanceURL = '';

  Future validateAccessToken(String accessToken, String? instanceURL) async {
    try {
      final response = await http.get(
        Uri.https(instanceURL ?? kAuthorityURL,
            '$kUnEncodedBaseURL/$kAccountDetailsURL'),
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
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveLoginCredentials(
      String accessToken, String instanceURL) async {
    await secureStorage.write(key: _accessTokenKey, value: accessToken);
    await secureStorage.write(key: _instanceURLKey, value: instanceURL);
  }

  Future<String> getAccessToken() async {
    if (_accessTokenValue.isEmpty) {
      _accessTokenValue = await secureStorage.read(key: _accessTokenKey) ?? '';
      return _accessTokenValue;
    } else {
      return _accessTokenValue;
    }
  }

  Future<String> getInstanceURL() async {
    final savedURL = await secureStorage.read(key: _instanceURLKey);
    if (savedURL == null) _instanceURL = kAuthorityURL;
    if (_instanceURL.isEmpty) {
      _instanceURL = await secureStorage.read(key: _instanceURLKey) ?? '';
      return _instanceURL;
    } else {
      return _instanceURL;
    }
  }
}
