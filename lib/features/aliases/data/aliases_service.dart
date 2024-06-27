import 'dart:async';

import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasesServiceProvider = Provider.autoDispose<AliasesService>((ref) {
  return AliasesService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorageProvider),
  );
});

class AliasesService extends BaseService {
  const AliasesService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = DataStorageKeys.aliasesKey,
  });

  Future<List<Alias>> fetchAliases({
    bool onlyDeletedAliases = false,
  }) async {
    const path = '$kUnEncodedBaseURL/aliases';
    final params = {
      'with': 'recipients',
      if (onlyDeletedAliases) "filter[deleted]": "only",
    };
    final response = await get(path, queryParameters: params);

    final aliases = response['data'] as List;
    return aliases.map((alias) => Alias.fromJson(alias)).toList();
  }

  Future<List<Alias>?> loadCachedData() async {
    final aliasesData = await loadData();
    if (aliasesData == null) return null;

    return (aliasesData['data'] as List)
        .map((recipient) => Alias.fromJson(recipient))
        .toList();
  }

  Future<List<Alias>> fetchAssociatedAliases(Map<String, String> params) async {
    const path = '$kUnEncodedBaseURL/aliases';
    final response = await get(path, queryParameters: params);
    final aliases = response['data'] as List;
    return aliases.map((alias) => Alias.fromJson(alias)).toList();
  }

  Future<Alias> createNewAlias({
    required String desc,
    required String localPart,
    required String domain,
    required String format,
    required List<String> recipients,
  }) async {
    const path = '$kUnEncodedBaseURL/aliases';
    final data = {
      "domain": domain,
      "format": format,
      "description": desc,
      "recipient_ids": recipients,
      if (format == 'custom') "local_part": localPart,
    };
    final response = await post(path, data: data);
    return Alias.fromJson(response['data']);
  }

  Future<Alias> updateAliasDefaultRecipient(
    String aliasID,
    List<String> recipientId,
  ) async {
    const path = '$kUnEncodedBaseURL/alias-recipients';
    final data = {"alias_id": aliasID, "recipient_ids": recipientId};
    final response = await post(path, data: data);
    return Alias.fromJson(response['data']);
  }
}
