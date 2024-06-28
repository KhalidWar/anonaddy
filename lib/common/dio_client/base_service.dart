import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/features/aliases/presentation/alias_screen.dart';
import 'package:anonaddy/features/app_version/domain/app_version.dart';
import 'package:anonaddy/features/domain_options/domain/domain_options.dart';
import 'package:anonaddy/features/domains/presentation/domain_screen.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Base class for all services.
///
/// Every service class should extend this class to access HTTP methods
/// and data storage along with solid error handling and logging.
abstract class BaseService {
  const BaseService({
    required this.dio,
    required this.secureStorage,
    this.storageKey,
    this.isDetailedScreen = false,
  });

  final Dio dio;
  final FlutterSecureStorage secureStorage;

  /// Key used to store API response in [secureStorage] for offline use which
  /// consists of a list of data such as [Alias], [Recipient], [Domain], etc.
  ///
  /// Every service class should provide a unique key defined in [DataStorageKeys].
  ///
  /// If null, data will not be stored which is okay when dealing with
  /// data that isn't needed when offline such as:
  ///   1. detailed screen: [AliasScreen], [DomainScreen], [RecipientsScreen], etc.
  ///   2. temporary data: [DomainOptions], [AppVersion].
  final String? storageKey;

  /// If true, data will not be stored in [secureStorage] for detailed screens.
  /// Instead, data will be fetched from the server every time the screen is opened.
  /// When offline, data will be fetched from [secureStorage] if available.
  final bool isDetailedScreen;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? childId,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      log('BaseService get($path): statusCode ${response.statusCode}');

      /// If [storageKey] is provided, save the response data in [secureStorage].
      if (!isDetailedScreen && storageKey != null) {
        await _saveData(response.data);
      }

      return response.data;
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
      if (responseData.isEmpty) return {};

      return responseData;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> delete(String path) async {
    try {
      final response = await dio.delete(path);
      log('BaseService delete($path): statusCode ${response.statusCode}');
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final encodedData = jsonEncode(data);
      final response = await dio.patch(path, data: encodedData);
      log('BaseService patch($path): statusCode ${response.statusCode}');

      final responseData = response.data;
      return responseData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> loadData([String? childId]) async {
    try {
      if (storageKey == null) return null;

      final allData = await secureStorage.readAll();

      if (childId != null) {
        final parentData = allData[storageKey];
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
      await secureStorage.write(value: encodedData, key: storageKey!);
    } catch (_) {
      return;
    }
  }
}
