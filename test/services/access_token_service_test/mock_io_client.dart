import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

class MockDio extends Mock implements Dio {
  @override
  Future<Response<T>> getUri<T>(Uri uri,
      {Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress}) async {
    return Response(
      statusCode: 200,
      requestOptions: RequestOptions(path: uri.path),
    );
  }
}
