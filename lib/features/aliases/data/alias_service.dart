import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/features/aliases/data/alias_data_storage.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasServiceProvider = Provider<AliasService>((ref) {
  return AliasService(
    dio: ref.read(dioProvider),
    dataStorage: ref.read(aliasDataStorageProvider),
  );
});

class AliasService {
  const AliasService({
    required this.dio,
    required this.dataStorage,
  });

  final Dio dio;
  final AliasDataStorage dataStorage;

  Future<List<Alias>> fetchAvailableAliases() async {
    try {
      const path = '$kUnEncodedBaseURL/aliases';
      final params = {'with': 'recipients'};
      final response = await dio.get(path, queryParameters: params);
      log('fetchAvailableAliases: ${response.statusCode}');
      final aliases = response.data['data'] as List;
      dataStorage.saveAliases(aliases: aliases, isAvailableAliases: true);
      return aliases.map((alias) => Alias.fromJson(alias)).toList();
    } on DioException catch (dioException) {
      if (dioException.type == DioExceptionType.connectionError) {
        final aliases = await dataStorage.loadAliases(isAvailableAliases: true);
        if (aliases != null) return aliases;
      }
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      throw 'Failed to fetch available aliases';
    }
  }

  Future<List<Alias>> fetchDeletedAliases() async {
    try {
      const path = '$kUnEncodedBaseURL/aliases';
      final params = {'deleted': 'only', 'with': 'recipients'};
      final response = await dio.get(path, queryParameters: params);
      log('fetchDeletedAliases: ${response.statusCode}');
      final aliases = response.data['data'] as List;
      dataStorage.saveAliases(aliases: aliases, isAvailableAliases: false);
      return aliases.map((alias) => Alias.fromJson(alias)).toList();
    } on DioException catch (dioException) {
      if (dioException.type == DioExceptionType.connectionError) {
        final aliases =
            await dataStorage.loadAliases(isAvailableAliases: false);
        if (aliases != null) return aliases;
      }
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      throw 'Failed to fetch deleted aliases';
    }
  }

  Future<List<Alias>> fetchAssociatedAliases(Map<String, String> params) async {
    try {
      const path = '$kUnEncodedBaseURL/aliases';
      final response = await dio.get(path, queryParameters: params);
      log('fetchAssociatedAliases: ${response.statusCode}');
      final aliases = response.data['data'] as List;
      return aliases.map((alias) => Alias.fromJson(alias)).toList();
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      throw 'Failed to fetch available aliases';
    }
  }

  Future<List<Alias>?> loadAvailableAliasesFromDisk() async {
    try {
      final availableAliases =
          await dataStorage.loadAliases(isAvailableAliases: true);
      return availableAliases;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Alias>?> loadDeletedAliasesFromDisk() async {
    try {
      final deletedAliases =
          await dataStorage.loadAliases(isAvailableAliases: false);
      return deletedAliases;
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> createNewAlias({
    required String desc,
    required String localPart,
    required String domain,
    required String format,
    required List<String> recipients,
  }) async {
    try {
      const path = '$kUnEncodedBaseURL/aliases';
      final data = json.encode({
        "domain": domain,
        "format": format,
        "description": desc,
        "recipient_ids": recipients,
        if (format == 'custom') "local_part": localPart,
      });
      final response = await dio.post(path, data: data);
      log('createNewAlias: ${response.statusCode}');
      return Alias.fromJson(response.data['data']);
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> updateAliasDefaultRecipient(
      String aliasID, List<String> recipientId) async {
    try {
      const path = '$kUnEncodedBaseURL/alias-recipients';
      final data =
          jsonEncode({"alias_id": aliasID, "recipient_ids": recipientId});
      final response = await dio.post(path, data: data);
      log('updateAliasDefaultRecipient: ${response.statusCode}');
      return Alias.fromJson(response.data['data']);
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }
}
