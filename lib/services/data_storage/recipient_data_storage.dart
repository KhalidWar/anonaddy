import 'dart:convert';

import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/services/data_storage/data_storage.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/data_storage_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final recipientDataStorageProvider = Provider<RecipientDataStorage>((ref) {
  return RecipientDataStorage(secureStorage: ref.read(flutterSecureStorage));
});

class RecipientDataStorage extends DataStorage {
  const RecipientDataStorage({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    try {
      final encodedData = jsonEncode(data);
      await secureStorage.write(
        key: DataStorageKeys.recipientKey,
        value: encodedData,
      );
    } catch (_) {
      return;
    }
  }

  @override
  Future<List<Recipient>> loadData() async {
    try {
      final data = await secureStorage.read(key: DataStorageKeys.recipientKey);
      final decodedData = jsonDecode(data ?? '');
      final recipients = (decodedData as List)
          .map((recipient) => Recipient.fromJson(recipient))
          .toList();
      return recipients;
    } catch (error) {
      rethrow;
    }
  }
}
