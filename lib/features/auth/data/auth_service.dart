import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/auth/data/api_error_message.dart';
import 'package:anonaddy/features/auth/domain/api_token.dart';
import 'package:anonaddy/features/auth/domain/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authServiceProvider = Provider.autoDispose<AuthService>((ref) {
  return AuthService(
    secureStorage: ref.read(flutterSecureStorageProvider),
    dio: Dio(),
  );
});

class AuthService {
  const AuthService({
    required this.secureStorage,
    required this.dio,
  });

  final FlutterSecureStorage secureStorage;
  final Dio dio;

  static const _user = 'user';

  Future<User> loginWithAccessToken(String url, String token) async {
    try {
      const path = '$kUnEncodedBaseURL/api-token-details';
      final uri = Uri.https(url, path);
      final options = Options(
        sendTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final response = await dio.getUri(uri, options: options);
      log('loginWithAccessToken: ${response.statusCode}');

      final apiToken = ApiToken.fromMap(response.data);
      return User(url: url, token: token, apiToken: apiToken);
    } on DioException catch (dioException) {
      throw dioException.response == null
          ? dioException.message ?? AppStrings.somethingWentWrong
          : ApiErrorMessage.translateStatusCode(
              dioException.response?.statusCode);
    } catch (error) {
      rethrow;
    }
  }

  Future<User> loginWithUsernameAndPassword(
    String username,
    String password, {
    String? instanceUrl,
  }) async {
    try {
      final url = instanceUrl ?? 'app.addy.io';
      final baseUrl = 'https://$url';
      final loginResponse = await dio.post(
        '$baseUrl/api/auth/login',
        data: jsonEncode({
          'username': username,
          'password': password,
          'device_name': AppStrings.appName,
        }),
      );

      final apiKey = loginResponse.data['api_key'];
      final tokenDetailsResponse = await dio.get(
        '$baseUrl/api/v1/api-token-details',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Accept": "application/json",
            "Authorization": "Bearer $apiKey",
          },
        ),
      );

      final apiToken = ApiToken.fromMap(tokenDetailsResponse.data);
      return User(url: url, token: apiKey, apiToken: apiToken);
    } on DioException catch (dioException) {
      throw dioException.response == null
          ? dioException.message ?? AppStrings.somethingWentWrong
          : ApiErrorMessage.translateStatusCode(
              dioException.response?.statusCode);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveUser(User user) async {
    final encodedUser = jsonEncode(user.toMap());
    await secureStorage.write(key: _user, value: encodedUser);
  }

  Future<User?> getUser() async {
    try {
      final userData = await secureStorage.read(key: _user);
      if (userData == null) return null;

      final decodedDate = jsonDecode(userData);
      final user = User.fromMap(decodedDate);
      return User(
        url: user.url,
        token: user.token,
        apiToken: user.apiToken,
      );
    } catch (error) {
      return null;
    }
  }
}
