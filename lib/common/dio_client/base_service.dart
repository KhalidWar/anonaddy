import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class BaseService {
  const BaseService({
    required this.dio,
    required this.secureStorage,
    required this.storageKey,
    this.parentStorageKey,
  }) : assert(!(storageKey == '' && parentStorageKey == null));

  final Dio dio;
  final FlutterSecureStorage secureStorage;
  final String storageKey;
  final String? parentStorageKey;

  Future<Map<String, dynamic>> get(
    String path, {
    String? childId,
  }) async {
    try {
      final response = await dio.get(path);
      log('BaseService getData($path): statusCode ${response.statusCode}');

      final responseData = response.data;
      if (storageKey.isNotEmpty) await _saveData(responseData);
      return responseData;
    } on DioException catch (dioException) {
      if (dioException.type == DioExceptionType.connectionError) {
        final loadedData = await loadData(childId);
        if (loadedData != null) return loadedData;
      }
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final encodedData = jsonEncode(data);
      final response = await dio.post(path, data: encodedData);
      log('BaseService post($path): statusCode ${response.statusCode}');

      final responseData = response.data;
      return responseData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> loadData([String? childId]) async {
    try {
      final allData = await secureStorage.readAll();

      if (parentStorageKey != null && childId != null) {
        final parentData = allData[parentStorageKey];
        if (parentData == null) return null;

        final decodedParentData = jsonDecode(parentData);
        final childData = (decodedParentData['data'] as List)
            .firstWhere((element) => element['id'] == childId);
        return {'data': childData};
      }

      final accessedData = allData[storageKey];
      if (accessedData == null) return null;

      return jsonDecode(accessedData);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveData(Map<String, dynamic> data) async {
    try {
      final encodedData = jsonEncode(data);
      await secureStorage.write(value: encodedData, key: storageKey);
    } catch (_) {
      return;
    }
  }
}
