import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {
  @override
  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress}) async {
    if (path == 'error') {
      throw DioError(
        error: 'Something went wrong',
        type: DioErrorType.response,
        requestOptions: RequestOptions(path: path),
        response: Response(
          data:
              {"version": "0.11.0", "major": 0, "minor": 11, "patch": 0} as T?,
          requestOptions: RequestOptions(path: path),
          statusCode: 404,
        ),
      );
    }

    return Response(
      data: {"version": "0.11.0", "major": 0, "minor": 11, "patch": 0} as T?,
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
    );
  }
}
