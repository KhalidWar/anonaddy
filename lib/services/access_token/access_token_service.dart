import 'dart:developer';

import 'package:anonaddy/shared_components/constants/secure_storage_keys.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccessTokenService {
  AccessTokenService({
    required this.secureStorage,
    required this.dio,
  });
  final FlutterSecureStorage secureStorage;
  final Dio dio;

  Future<bool> validateAccessToken(String url, String token) async {
    try {
      const path = '$kUnEncodedBaseURL/$kAccountDetailsURL';
      final uri = Uri.https(url, path);
      final options = Options(
        sendTimeout: 5000,
        receiveTimeout: 5000,
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final response = await dio.getUri(uri, options: options);
      log('validateAccessToken: ' + response.statusCode.toString());

      return response.statusCode == 200 ? true : false;
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.response) {
        throw dioError.response == null
            ? dioError.message
            : ApiErrorMessage.translateStatusCode(
                dioError.response!.statusCode ?? 0);
      }
      throw dioError.error.message;
    } catch (error) {
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
