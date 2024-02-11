import 'dart:developer';

import 'package:anonaddy/features/rules/domain/rules.dart';
import 'package:anonaddy/services/data_storage/rules_data_storage.dart';
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

  Future<List<Rules>> fetchAllRules() async {
    try {
      const path = '$kUnEncodedBaseURL/rules';
      final response = await dio.get(path);
      log('fetchAllRules: ${response.statusCode}');
      dataStorage.saveData(response.data);

      final rules = response.data['data'] as List;
      return rules.map((rule) => Rules.fromJson(rule)).toList();
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.other) {
        final rules = await dataStorage.loadData();
        return rules;
      }
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Rules>> loadRulesFromDisk() async {
    try {
      return await dataStorage.loadData();
    } catch (error) {
      rethrow;
    }
  }
}
