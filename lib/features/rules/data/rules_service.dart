import 'dart:developer';

import 'package:anonaddy/features/rules/data/rules_data_storage.dart';
import 'package:anonaddy/features/rules/domain/rule.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/dio_client/dio_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rulesService = Provider<RulesService>((ref) {
  return RulesService(
    dio: ref.read(dioProvider),
    dataStorage: ref.read(rulesDataStorageProvider),
  );
});

class RulesService {
  const RulesService({
    required this.dio,
    required this.dataStorage,
  });
  final Dio dio;
  final RulesDataStorage dataStorage;

  Future<List<Rule>> fetchRules() async {
    try {
      const path = '$kUnEncodedBaseURL/rules';
      final response = await dio.get(path);
      log('fetchRules: ${response.statusCode}');
      dataStorage.saveData(response.data);

      final rules = response.data['data'] as List;
      return rules.map((rule) => Rule.fromJson(rule)).toList();
    } on DioException catch (dioException) {
      if (dioException.type == DioExceptionType.connectionError) {
        final rules = await dataStorage.loadData();
        if (rules != null) return rules;
      }
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Rule>?> loadRulesFromDisk() async {
    try {
      return await dataStorage.loadData();
    } catch (error) {
      rethrow;
    }
  }
}
