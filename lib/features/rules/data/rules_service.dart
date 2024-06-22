import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/rules/domain/rule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rulesServiceProvider = Provider<RulesService>((ref) {
  return RulesService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorageProvider),
  );
});

class RulesService extends BaseService {
  RulesService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = DataStorageKeys.rulesKey,
  });

  Future<List<Rule>> fetchRules() async {
    const path = '$kUnEncodedBaseURL/rules';
    final response = await get(path);

    final rules = response['data'] as List;
    return rules.map((rule) => Rule.fromJson(rule)).toList();
  }

  Future<List<Rule>?> loadCachedData() async {
    final recipientsData = await loadData();
    if (recipientsData == null) return null;

    return (recipientsData['data'] as List)
        .map((recipient) => Rule.fromJson(recipient))
        .toList();
  }
}
