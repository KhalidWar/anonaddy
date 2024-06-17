import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/features/app_version/domain/app_version.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appVersionService = Provider<AppVersionService>((ref) {
  return AppVersionService(dio: ref.read(dioProvider));
});

class AppVersionService {
  const AppVersionService({required this.dio});
  final Dio dio;

  Future<AppVersion> getAppVersionData() async {
    try {
      const urlPath = '$kUnEncodedBaseURL/app-version';
      final response = await dio.get(urlPath);
      final appVersion = AppVersion.fromJson(response.data);
      log('getAppVersionData: ${response.statusCode}');

      return appVersion;
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> fetchLatestAddyAppVersion() async {
    try {
      const urlPath = 'https://api.github.com/repos/anonaddy/anonaddy/releases';
      final response = await Dio().get(urlPath);
      final latestAppVersion = (response.data as List).first;
      log('fetchLatestAddyAppVersion: ${response.statusCode}');

      return latestAppVersion['tag_name'];
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }
}
