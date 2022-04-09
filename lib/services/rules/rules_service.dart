import 'dart:developer';

import 'package:anonaddy/models/rules/rules.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';

class RulesService {
  const RulesService(this.dio);
  final Dio dio;

  Future<List<Rules>> getAllRules() async {
    try {
      const path = '$kUnEncodedBaseURL/$kRulesURL';
      final response = await dio.get(path);
      log('getAllRules: ' + response.statusCode.toString());

      final rules = response.data['data'] as List;
      return rules.map((rule) => Rules.fromJson(rule)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
