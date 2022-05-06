import 'dart:developer';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/app_version/app_version_model.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
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
