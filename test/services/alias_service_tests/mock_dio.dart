import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

import '../../test_data/alias_test_data.dart';

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
          data: AliasTestData.validAliasJson as T?,
          statusCode: 404,
          requestOptions: RequestOptions(path: path),
        ),
      );
    }

    return Response<T>(
      data: AliasTestData.validAliasJson as T?,
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response<T>> post<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    if (path == 'error') {
      throw DioError(
        requestOptions: RequestOptions(path: path),
        error: 'Something went wrong',
        type: DioErrorType.response,
        response: Response<T>(
          data: AliasTestData.validAliasJson as T?,
          statusCode: 404,
          requestOptions: RequestOptions(path: path),
        ),
      );
    }

    return Response<T>(
      data: AliasTestData.validAliasJson as T?,
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response<T>> delete<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    if (path == 'error') {
      throw DioError(
        requestOptions: RequestOptions(path: path),
        error: 'Something went wrong',
        type: DioErrorType.response,
        response: Response<T>(
          data: AliasTestData.validAliasJson as T?,
          statusCode: 404,
          requestOptions: RequestOptions(path: path),
        ),
      );
    }

    return Response<T>(
      data: {} as T?,
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
  }
}
