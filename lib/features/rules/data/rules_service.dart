import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/features/rules/data/rules_data_storage.dart';
import 'package:anonaddy/features/rules/domain/rule.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rulesServiceProvider = Provider<RulesService>((ref) {
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

  Future<Rule> fetchSpecificRule(String ruleId) async {
    try {
      final path = '$kUnEncodedBaseURL/rules/$ruleId';
      final response = await dio.get(path);
      log('fetchSpecificRule: ${response.statusCode}');
      return Rule.fromJson(response.data['data']);
    } on DioException catch (dioException) {
      if (dioException.type == DioExceptionType.connectionError) {
        final rule = await dataStorage.loadSpecificRule(ruleId);
        if (rule != null) return rule;
      }
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<Rule> updateRule(String ruleId, Map<String, dynamic> data) async {
    try {
      final path = '$kUnEncodedBaseURL/rules/$ruleId';
      final response = await dio.patch(path, data: data);
      log('updateRule: ${response.statusCode}');
      return Rule.fromJson(response.data['data']);
    } on DioException catch (dioException) {
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
