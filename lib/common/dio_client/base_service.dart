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
  });

  final Dio dio;
  final FlutterSecureStorage secureStorage;
  final String storageKey;

  Future<Map<String, dynamic>> get({required String path}) async {
    try {
      final response = await dio.get(path);
      log('BaseService getData(): statusCode ${response.statusCode}');

      final responseData = response.data;
      await _saveData(responseData);
      return responseData;
    } on DioException catch (dioException) {
      if (dioException.type == DioExceptionType.connectionError) {
        final loadedData = await loadData();
        if (loadedData != null) return loadedData;
      }
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> loadData() async {
    try {
      final data = await secureStorage.read(key: storageKey);
      log('BaseService loadData()');

      if (data == null) return null;

      return jsonDecode(data);
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
