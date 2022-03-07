import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

import 'dummy_alias_data.dart';

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
        error: 'Something went wrong',
        type: DioErrorType.response,
        response: Response<T>(
          data: dummyAliasData as T?,
          statusCode: 200,
          requestOptions: RequestOptions(path: path),
        ),
      );
    }

    return Response<T>(
      data: dummyAliasData as T?,
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
  }
}
