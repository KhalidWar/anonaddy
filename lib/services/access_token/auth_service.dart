import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/features/auth/domain/api_token.dart';
import 'package:anonaddy/features/auth/domain/user.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/secure_storage_keys.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
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
      log('fetchApiTokenData: ${response.statusCode}');

      return ApiToken.fromMap(response.data);
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

  Future<void> saveUser(User user) async {
    final encodedUser = jsonEncode(user.toMap());
    await secureStorage.write(key: SecureStorageKeys.user, value: encodedUser);
  }

  Future<User?> getUser() async {
    try {
      final userData = await secureStorage.read(key: SecureStorageKeys.user);
      if (userData == null) return null;

      final decodedDate = jsonDecode(userData);
      return User.fromMap(decodedDate);
    } catch (error) {
      rethrow;
    }
  }
}
