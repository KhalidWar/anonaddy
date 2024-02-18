import 'dart:developer';

import 'package:anonaddy/features/app_version/domain/app_version.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/dio_client/dio_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appVersionService = Provider<AppVersionService>((ref) {
  return AppVersionService(dio: ref.read(dioProvider));
});

class AppVersionService {
  const AppVersionService({required this.dio});
  final Dio dio;

  Future<AppVersion> getAppVersionData([String? path]) async {
    try {
      const urlPath = '$kUnEncodedBaseURL/app-version';
      final response = await dio.get(path ?? urlPath);
      final appVersion = AppVersion.fromJson(response.data);
      log('getAppVersionData: ${response.statusCode}');

      return appVersion;
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }
}
