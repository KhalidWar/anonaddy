import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/features/auth/domain/api_token.dart';
import 'package:anonaddy/features/auth/domain/user.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/secure_storage_keys.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:anonaddy/utilities/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    secureStorage: ref.read(flutterSecureStorage),
    dio: Dio(),
  );
});

class AuthService {
  AuthService({
    required this.secureStorage,
    required this.dio,
  });
  final FlutterSecureStorage secureStorage;
  final Dio dio;

  Future<ApiToken> fetchApiTokenData(String url, String token) async {
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
      log('fetchApiTokenData: ${response.statusCode}');

      return ApiToken.fromMap(response.data);
    } on DioException catch (dioException) {
      if (dioException.type == DioExceptionType.badResponse) {
        throw dioException.response == null
            ? dioException.message ?? AppStrings.somethingWentWrong
            : ApiErrorMessage.translateStatusCode(
                dioException.response?.statusCode ?? 0);
      }
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveUser(User user) async {
    final encodedUser = jsonEncode(user.toMap());
    await secureStorage.write(key: SecureStorageKeys.user, value: encodedUser);
  }

  Future<User?> getUser() async {
    try {
      final userData = await secureStorage.read(key: SecureStorageKeys.user);
      if (userData == null) return null;

      final decodedDate = jsonDecode(userData);
      final user = User.fromMap(decodedDate);

      return User(
        url: user.url == 'app.anonaddy.com' ? 'app.addy.io' : user.url,
        token: user.token,
        apiToken: user.apiToken,
      );
    } catch (error) {
      rethrow;
    }
  }
}
