import 'dart:developer';

import 'package:anonaddy/models/app_version/app_version_model.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';

class AppVersionService {
  const AppVersionService(this.dio);
  final Dio dio;

  Future<AppVersion> getAppVersionData([String? path]) async {
    try {
      const urlPath = '$kUnEncodedBaseURL/$kAppVersionURL';
      final response = await dio.get(path ?? urlPath);
      final appVersion = AppVersion.fromJson(response.data);
      log('getAppVersionData: ' + response.statusCode.toString());

      return appVersion;
    } catch (e) {
      rethrow;
    }
  }
}
