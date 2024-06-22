import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/rules/domain/rule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ruleScreenServiceProvider = Provider<RuleScreenService>((ref) {
  return RuleScreenService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorageProvider),
  );
});

class RuleScreenService extends BaseService {
  RuleScreenService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = '',
    super.parentStorageKey = DataStorageKeys.rulesKey,
  });

  Future<Rule> fetchSpecificRule(String ruleId) async {
    final path = '$kUnEncodedBaseURL/rules/$ruleId';
    final response = await get(path, childId: ruleId);
    return Rule.fromJson(response['data']);
  }

  Future<Rule> updateRule(String ruleId, Map<String, dynamic> data) async {
    final path = '$kUnEncodedBaseURL/rules/$ruleId';
    final response = await patch(path, data: data);
    return Rule.fromJson(response['data']);
  }
}
