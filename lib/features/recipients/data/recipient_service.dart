import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientService = Provider.autoDispose<RecipientService>((ref) {
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
    const path = '$kUnEncodedBaseURL/recipients';
    final response = await get(path);

    final recipientData = response['data'];
    return (recipientData as List)
        .map((recipient) => Recipient.fromJson(recipient))
        .toList();
  }

  Future<List<Recipient>?> loadCachedData() async {
    final recipientsData = await loadData();
    if (recipientsData == null) return null;

    return (recipientsData['data'] as List)
        .map((recipient) => Recipient.fromJson(recipient))
        .toList();
  }

  Future<Recipient> addRecipient(String email) async {
    const path = '$kUnEncodedBaseURL/recipients';
    final response = await post(path, data: {"email": email});
    return Recipient.fromJson(response['data']);
  }
}
