import 'package:anonaddy/services/dio_client/dio_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Class Providers
final flutterSecureStorage = Provider((ref) => const FlutterSecureStorage());

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final interceptors = ref.read(dioInterceptorProvider);
  dio.interceptors.add(interceptors);
  return dio;
});
