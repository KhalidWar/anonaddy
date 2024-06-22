import 'dart:async';

import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/domains/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainService = Provider.autoDispose<DomainsService>((ref) {
  return DomainsService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorageProvider),
  );
});

class DomainsService extends BaseService {
  const DomainsService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = DataStorageKeys.domainKey,
  });

  Future<List<Domain>> fetchDomains() async {
    try {
      const path = '$kUnEncodedBaseURL/domains';
      final response = await get(path);

      final domainData = response['data'] as List;
      final domains =
          domainData.map((domain) => Domain.fromJson(domain)).toList();
      return domains;
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> addNewDomain(String domain) async {
    const path = '$kUnEncodedBaseURL/domains';
    final response = await post(path, data: {"domain": domain});
    return Domain.fromJson(response['data']);
  }

  Future<List<Domain>?> loadCachedData() async {
    final domainData = await loadData();
    if (domainData == null) return null;

    return (domainData['data'] as List)
        .map((recipient) => Domain.fromJson(recipient))
        .toList();
  }
}
