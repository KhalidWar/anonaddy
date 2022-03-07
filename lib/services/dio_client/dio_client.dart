import 'package:anonaddy/services/dio_client/dio_interceptors.dart';
import 'package:dio/dio.dart';

/// This class is responsible for making all HTTP operations to AnonAddy's API.
class DioClient {
  DioClient(this.dioInterceptors) {
    dio = Dio();
    dio.interceptors.add(dioInterceptors);
  }

  late final Dio dio;
  final DioInterceptors dioInterceptors;
}
