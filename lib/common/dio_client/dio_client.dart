import 'package:anonaddy/features/auth/data/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider.autoDispose<Dio>((ref) {
  final dio = Dio();
  final interceptors = ref.read(_dioInterceptorProvider);
  dio.interceptors.add(interceptors);
  return dio;
});

final _dioInterceptorProvider = Provider.autoDispose<DioInterceptors>((ref) {
  //TODO: Replace with [authNotifierProvider]
  final accessTokenService = ref.read(authServiceProvider);
  return DioInterceptors(authService: accessTokenService);
});

class DioInterceptors extends Interceptor {
  DioInterceptors({required this.authService});

  final AuthService authService;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final user = await authService.getUser();
    final customOptions = options.copyWith(
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      baseUrl: 'https://${user?.url}',
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Accept": "application/json",
        "Authorization": "Bearer ${user?.token}",
      },
    );

    return handler.next(customOptions);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionError:
        return handler.next(
          err.copyWith(message: 'No internet connection, please try again.'),
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return handler.next(
          err.copyWith(message: 'Connection has timed out, please try again.'),
        );
      case DioExceptionType.cancel:
        return handler.next(
          err.copyWith(message: 'Request cancelled'),
        );
      case DioExceptionType.badResponse:
        return handler.next(err.stringifyStatusCode);
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return handler.next(
          err.copyWith(message: 'Something went wrong, please try again.'),
        );
    }
  }
}

extension DioExceptionExtension on DioException {
  DioException get stringifyStatusCode {
    switch (response?.statusCode) {
      case 400:
        return copyWith(message: 'Bad Request -- Your request sucks');
      case 401:
        return copyWith(message: 'Unauthenticated -- Your API key is wrong');
      case 403:
        return copyWith(
          message:
              'Forbidden -- You do not have permission to access the requested resource',
        );
      case 404:
        return copyWith(
          message: 'Not Found -- The specified resource could not be found',
        );
      case 405:
        return copyWith(
          message:
              'Method Not Allowed -- You tried to access an endpoint with an invalid method',
        );
      case 422:
        return copyWith(
          message: 'Validation Error -- The given data was invalid',
        );
      case 429:
        return copyWith(
          message:
              'Too Many Requests -- You\'re sending too many requests or have reached your limit for new aliases',
        );
      case 500:
        return copyWith(
          message:
              'Internal Server Error -- We had a problem with our server. Try again later',
        );
      case 503:
        return copyWith(
          message:
              'Service Unavailable -- We\'re temporarily offline for maintenance. Please try again later',
        );
    }
    return copyWith(message: 'Something went wrong, please try again.');
  }
}
