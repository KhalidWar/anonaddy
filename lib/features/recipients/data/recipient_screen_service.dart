import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientScreenService = Provider<RecipientScreenService>((ref) {
  return RecipientScreenService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorageProvider),
  );
});

class RecipientScreenService extends BaseService {
  const RecipientScreenService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = '',
    super.parentStorageKey = DataStorageKeys.recipientKey,
  });

  Future<Recipient> fetchRecipient(String recipientId) async {
    try {
      final path = '$kUnEncodedBaseURL/recipients/$recipientId';
      final response = await get(path, childId: recipientId);
      final recipient = response['data'];
      return Recipient.fromJson(recipient);
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipient> enableEncryption(String recipientID) async {
    try {
      const path = '$kUnEncodedBaseURL/encrypted-recipients';
      final response = await post(path, data: {"id": recipientID});
      final recipient = response['data'];
      return Recipient.fromJson(recipient);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableEncryption(String recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/encrypted-recipients/$recipientID';
      await delete(path);
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipient> addPublicGPGKey(String recipientID, String keyData) async {
    try {
      final path = '$kUnEncodedBaseURL/recipient-keys/$recipientID';
      final response = await patch(path, data: {"key_data": keyData});
      final recipient = response['data'];
      return Recipient.fromJson(recipient);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removePublicGPGKey(String recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/recipient-keys/$recipientID';
      await delete(path);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeRecipient(String recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/recipients/$recipientID';
      await delete(path);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendVerificationEmail(String recipientID) async {
    try {
      const path = '$kUnEncodedBaseURL/recipients/email/resend';
      await post(path, data: {"recipient_id": recipientID});
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipient> enableReplyAndSend(String recipientId) async {
    try {
      const path = '$kUnEncodedBaseURL/allowed-recipients';
      final response = await post(path, data: {"id": recipientId});
      final recipient = response['data'];
      return Recipient.fromJson(recipient);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableReplyAndSend(String recipientId) async {
    try {
      final path = '$kUnEncodedBaseURL/allowed-recipients/$recipientId';
      await delete(path);
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipient> enableInlineEncryption(String recipientId) async {
    try {
      const path = '$kUnEncodedBaseURL/inline-encrypted-recipients';
      final response = await post(path, data: {"id": recipientId});
      final recipient = response['data'];
      return Recipient.fromJson(recipient);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableInlineEncryption(String recipientId) async {
    try {
      final path =
          '$kUnEncodedBaseURL/inline-encrypted-recipients/$recipientId';
      await delete(path);
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipient> enableProtectedHeader(String recipientId) async {
    try {
      const path = '$kUnEncodedBaseURL/protected-headers-recipients';
      final response = await post(path, data: {"id": recipientId});
      final recipient = response['data'];
      return Recipient.fromJson(recipient);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableProtectedHeader(String recipientId) async {
    try {
      await delete(
        '$kUnEncodedBaseURL/protected-headers-recipients/$recipientId',
      );
    } catch (e) {
      rethrow;
    }
  }
}
