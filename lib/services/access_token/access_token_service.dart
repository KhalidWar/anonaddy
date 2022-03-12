import 'package:anonaddy/shared_components/constants/secure_storage_keys.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';

class AccessTokenService {
  AccessTokenService({
    required this.secureStorage,
    required this.httpClient,
  });
  final FlutterSecureStorage secureStorage;
  final IOClient httpClient;

  Future<bool> validateAccessToken(String url, String token) async {
    try {
      final response = await httpClient.get(
        Uri.https(url, '$kUnEncodedBaseURL/$kAccountDetailsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveLoginCredentials(String url, String token) async {
    await secureStorage.write(
        key: SecureStorageKeys.accessTokenKey, value: token);
    await secureStorage.write(
        key: SecureStorageKeys.instanceURLKey, value: url);
  }

  Future<String> getAccessToken(
      {String key = SecureStorageKeys.accessTokenKey}) async {
    final accessToken = await secureStorage.read(key: key);
    return accessToken ?? '';
  }

  Future<String> getInstanceURL() async {
    final savedURL =
        await secureStorage.read(key: SecureStorageKeys.instanceURLKey);
    return savedURL ?? '';
  }
}
