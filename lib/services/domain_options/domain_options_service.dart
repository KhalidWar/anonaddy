import 'dart:async';
import 'dart:developer';

import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';

class DomainOptionsService {
  const DomainOptionsService(this.dio);
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
