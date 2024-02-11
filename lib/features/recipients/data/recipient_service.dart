import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/features/recipients/data/recipient_data_storage.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/dio_client/dio_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientService = Provider<RecipientService>((ref) {
  return RecipientService(
    dio: ref.read(dioProvider),
    recipientDataStorage: ref.read(recipientDataStorageProvider),
  );
});

class RecipientService {
  const RecipientService({
    required this.dio,
    required this.recipientDataStorage,
  });
  final Dio dio;
  final RecipientDataStorage recipientDataStorage;

  Future<List<Recipient>> fetchRecipients() async {
    try {
      const path = '$kUnEncodedBaseURL/recipients';
      final response = await dio.get(path);
      log('fetchRecipients: ${response.statusCode}');
      recipientDataStorage.saveData(response.data);
      final recipientData = response.data['data'];
      final recipients = (recipientData as List)
          .map((recipient) => Recipient.fromJson(recipient))
          .toList();
      return recipients;
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.other) {
        final recipients = await recipientDataStorage.loadData();
        if (recipients != null) return recipients;
      }
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Recipient>?> loadRecipientsFromDisk() async {
    try {
      final recipients = await recipientDataStorage.loadData();
      return recipients;
    } catch (error) {
      rethrow;
    }
  }

  Future<Recipient> fetchSpecificRecipient(String recipientId) async {
    try {
      final path = '$kUnEncodedBaseURL/recipients/$recipientId';
      final response = await dio.get(path);
      log('getSpecificRecipient: ${response.statusCode}');
      final recipient = response.data['data'];
      return Recipient.fromJson(recipient);
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.other) {
        final recipient =
            await recipientDataStorage.loadSpecificRecipient(recipientId);
        return recipient;
      }
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipient> enableEncryption(String recipientID) async {
    try {
      const path = '$kUnEncodedBaseURL/encrypted-recipients';
      final data = json.encode({"id": recipientID});
      final response = await dio.post(path, data: data);
      log('enableEncryption: ${response.statusCode}');
      final recipient = response.data['data'];
      return Recipient.fromJson(recipient);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableEncryption(String recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/encrypted-recipients/$recipientID';
      final response = await dio.delete(path);
      log('disableEncryption: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipient> addPublicGPGKey(String recipientID, String keyData) async {
    try {
      final path = '$kUnEncodedBaseURL/recipient-keys/$recipientID';
      final data = jsonEncode({"key_data": keyData});
      final response = await dio.patch(path, data: data);
      log('addPublicGPGKey: ${response.statusCode}');
      final recipient = response.data['data'];
      return Recipient.fromJson(recipient);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removePublicGPGKey(String recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/recipient-keys/$recipientID';
      final response = await dio.delete(path);
      log('removePublicGPGKey: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipient> addRecipient(String email) async {
    try {
      const path = '$kUnEncodedBaseURL/recipients';
      final data = jsonEncode({"email": email});
      final response = await dio.post(path, data: data);
      log('addRecipient: ${response.statusCode}');
      final recipient = response.data['data'];
      return Recipient.fromJson(recipient);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeRecipient(String recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/recipients/$recipientID';
      final response = await dio.delete(path);
      log('removeRecipient: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendVerificationEmail(String recipientID) async {
    try {
      const path = '$kUnEncodedBaseURL/recipients/email/resend';
      final data = json.encode({"recipient_id": recipientID});
      final response = await dio.post(path, data: data);
      log('resendVerificationEmail: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipient> enableReplyAndSend(String recipientId) async {
    try {
      const path = '$kUnEncodedBaseURL/allowed-recipients';
      final data = json.encode({"id": recipientId});
      final response = await dio.post(path, data: data);
      log('enableReplyAndSend: ${response.statusCode}');
      final recipient = response.data['data'];
      return Recipient.fromJson(recipient);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableReplyAndSend(String recipientId) async {
    try {
      final path = '$kUnEncodedBaseURL/allowed-recipients/$recipientId';
      final response = await dio.delete(path);
      log('disableReplyAndSend: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipient> enableInlineEncryption(String recipientId) async {
    try {
      const path = '$kUnEncodedBaseURL/inline-encrypted-recipients';
      final data = json.encode({"id": recipientId});
      final response = await dio.post(path, data: data);
      log('enableInlineEncryption: ${response.statusCode}');
      final recipient = response.data['data'];
      return Recipient.fromJson(recipient);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableInlineEncryption(String recipientId) async {
    try {
      final path =
          '$kUnEncodedBaseURL/inline-encrypted-recipients/$recipientId';
      final response = await dio.delete(path);
      log('disableInlineEncryption: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipient> enableProtectedHeader(String recipientId) async {
    try {
      const path = '$kUnEncodedBaseURL/protected-headers-recipients';
      final data = json.encode({"id": recipientId});
      final response = await dio.post(path, data: data);
      log('enableProtectedHeader: ${response.statusCode}');
      final recipient = response.data['data'];
      return Recipient.fromJson(recipient);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableProtectedHeader(String recipientId) async {
    try {
      final path =
          '$kUnEncodedBaseURL/protected-headers-recipients/$recipientId';
      final response = await dio.delete(path);
      log('disableProtectedHeader: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }
}
