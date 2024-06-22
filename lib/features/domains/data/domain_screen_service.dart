import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/domains/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainScreenService = Provider<DomainScreenService>((ref) {
  return DomainScreenService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorageProvider),
  );
});

class DomainScreenService extends BaseService {
  DomainScreenService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = '',
    super.parentStorageKey = DataStorageKeys.domainKey,
  });

  Future<Domain> fetchSpecificDomain(String domainId) async {
    final path = '$kUnEncodedBaseURL/domains/$domainId';
    final response = await get(path, childId: domainId);
    return Domain.fromJson(response['data']);
  }

  Future<Domain> updateDomainDescription(
      String domainID, String description) async {
    final path = '$kUnEncodedBaseURL/domains/$domainID';
    final response = await patch(path, data: {"description": description});
    return Domain.fromJson(response['data']);
  }

  Future<void> deleteDomain(String domainID) async {
    final path = '$kUnEncodedBaseURL/domains/$domainID';
    await delete(path);
  }

  Future<Domain> updateDomainDefaultRecipient(
      String domainID, String? recipientID) async {
    final response = await patch(
      '$kUnEncodedBaseURL/domains/$domainID/default-recipient',
      data: {"default_recipient": recipientID},
    );
    return Domain.fromJson(response['data']);
  }

  Future<Domain> activateDomain(String domainID) async {
    const path = '$kUnEncodedBaseURL/active-domains';
    final response = await post(path, data: {"id": domainID});
    return Domain.fromJson(response['data']);
  }

  Future<void> deactivateDomain(String domainID) async {
    final path = '$kUnEncodedBaseURL/active-domains/$domainID';
    await delete(path);
  }

  Future<Domain> activateCatchAll(String domainID) async {
    const path = '$kUnEncodedBaseURL/catch-all-domains';
    final response = await post(path, data: {"id": domainID});
    return Domain.fromJson(response['data']);
  }

  Future deactivateCatchAll(String domainID) async {
    final path = '$kUnEncodedBaseURL/catch-all-domains/$domainID';
    await delete(path);
  }
}
