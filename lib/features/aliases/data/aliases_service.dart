import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/flutter_secure_storage.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasesServiceProvider = Provider<AliasesService>((ref) {
  return AliasesService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorage),
  );
});

class AliasesService extends BaseService {
  const AliasesService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = DataStorageKeys.aliasesKey,
  });

  Future<List<Alias>> fetchAliases() async {
    try {
      const path = '$kUnEncodedBaseURL/aliases';
      final params = {'with': 'recipients'};
      final response = await get(path, queryParameters: params);

      final aliases = response['data'] as List;
      return aliases.map((alias) => Alias.fromJson(alias)).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<List<Alias>?> loadCachedData() async {
    try {
      final aliasesData = await loadData();
      if (aliasesData == null) return null;

      final aliases = (aliasesData['data'] as List)
          .map((recipient) => Alias.fromJson(recipient))
          .toList();
      return aliases;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Alias>> fetchAssociatedAliases(Map<String, String> params) async {
    try {
      const path = '$kUnEncodedBaseURL/aliases';
      final response = await get(path, queryParameters: params);
      final aliases = response['data'] as List;
      return aliases.map((alias) => Alias.fromJson(alias)).toList();
    } catch (e) {
      throw 'Failed to fetch available aliases';
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
    String aliasID,
    List<String> recipientId,
  ) async {
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
