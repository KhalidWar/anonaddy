import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientService = Provider<RecipientService>((ref) {
  return RecipientService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorageProvider),
  );
});

class RecipientService extends BaseService {
  const RecipientService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = DataStorageKeys.recipientKey,
  });

  Future<List<Recipient>> fetchRecipients() async {
    try {
      const path = '$kUnEncodedBaseURL/recipients';
      final response = await get(path);

      final recipientData = response['data'];
      final recipients = (recipientData as List)
          .map((recipient) => Recipient.fromJson(recipient))
          .toList();
      return recipients;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Recipient>?> loadCachedData() async {
    try {
      final recipientsData = await loadData();
      if (recipientsData == null) return null;

      final recipients = (recipientsData['data'] as List)
          .map((recipient) => Recipient.fromJson(recipient))
          .toList();
      return recipients;
    } catch (error) {
      rethrow;
    }
  }

  Future<Recipient> addRecipient(String email) async {
    try {
      const path = '$kUnEncodedBaseURL/recipients';
      final response = await post(path, data: {"email": email});
      return Recipient.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }
}
