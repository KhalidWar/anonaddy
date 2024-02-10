import 'package:anonaddy/services/access_token/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final interceptors = ref.read(_dioInterceptorProvider);
  dio.interceptors.add(interceptors);
  return dio;
});

final _dioInterceptorProvider = Provider<DioInterceptors>((ref) {
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

    final headers = {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Accept": "application/json",
      "Authorization": "Bearer ${user!.token}",
    };

    options.baseUrl = 'https://${user.url}';
    options.headers.addAll(headers);

    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw 'Connection has timed out, please try again.';
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        throw 'No internet connection, please try again.';

      case DioErrorType.response:
        switch (err.response?.statusCode) {
          case 400:
            throw _responseError(err, 'Bad Request -- Your request sucks');
          case 401:
            throw _responseError(
              err,
              'Unauthenticated -- Your API key is wrong',
            );
          case 403:
            throw _responseError(
              err,
              'Forbidden -- You do not have permission to access the requested resource',
            );
          case 404:
            throw _responseError(
              err,
              'Not Found -- The specified resource could not be found',
            );
          case 405:
            throw _responseError(
              err,
              'Method Not Allowed -- You tried to access an endpoint with an invalid method',
            );
          case 422:
            throw _responseError(
                err, 'Validation Error -- The given data was invalid');
          case 429:
            throw _responseError(
              err,
              'Too Many Requests -- You\'re sending too many requests or have reached your limit for new aliases',
            );
          case 500:
            throw _responseError(
              err,
              'Internal Server Error -- We had a problem with our server. Try again later',
            );
          case 503:
            throw _responseError(
              err,
              'Service Unavailable -- We\'re temporarily offline for maintenance. Please try again later',
            );
        }
        break;
    }

    return handler.next(err);
  }

  DioError _responseError(DioError err, String message) {
    return DioError(
      type: DioErrorType.response,
      requestOptions: err.requestOptions,
      error: message,
    );
  }
}
