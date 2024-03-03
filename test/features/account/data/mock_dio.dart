import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

import 'dummy_account_data.dart';

class MockDio extends Mock implements Dio {
  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (path == 'error') {
      throw DioError(
        requestOptions: RequestOptions(path: path),
        error: 'Too many requests',
        response: Response<T>(
          data: dummyAccountData as T?,
          statusCode: 429,
          requestOptions: RequestOptions(path: path),
        ),
      );
    }

    return Response<T>(
      data: dummyAccountData as T?,
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
  }
}
