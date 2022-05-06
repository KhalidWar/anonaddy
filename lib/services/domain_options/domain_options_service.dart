import 'dart:async';
import 'dart:developer';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainOptionsService = Provider<DomainOptionsService>((ref) {
  return DomainOptionsService(dio: ref.read(dioProvider));
});

class DomainOptionsService {
  const DomainOptionsService({required this.dio});
  final Dio dio;

  Future<DomainOptions> getDomainOptions() async {
    try {
      const path = '$kUnEncodedBaseURL/$kDomainsOptionsURL';
      final response = await dio.get(path);
      log('getDomainOptions: ' + response.statusCode.toString());
      return DomainOptions.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
