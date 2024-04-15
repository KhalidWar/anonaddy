import 'dart:async';
import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/features/domain_options/domain/domain_options.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainOptionsService = Provider<DomainOptionsService>((ref) {
  return DomainOptionsService(dio: ref.read(dioProvider));
});

class DomainOptionsService {
  const DomainOptionsService({
    required this.dio,
  });
  final Dio dio;

  Future<DomainOptions> fetchDomainOptions() async {
    try {
      const path = '$kUnEncodedBaseURL/domain-options';
      final response = await dio.get(path);
      log('fetchDomainOptions: ${response.statusCode}');
      return DomainOptions.fromJson(response.data);
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }
}
