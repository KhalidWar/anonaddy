import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/flutter_secure_storage.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientScreenService = Provider<RecipientScreenService>((ref) {
  return RecipientScreenService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorage),
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
      final data = json.encode({"id": recipientID});
      final response = await dio.post(path, data: data);
      log('enableEncryption: ${response.statusCode}');
      final recipient = response.data['data'];
      return Recipient.fromJson(recipient);
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableEncryption(String recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/encrypted-recipients/$recipientID';
      final response = await dio.delete(path);
      log('disableEncryption: ${response.statusCode}');
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removePublicGPGKey(String recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/recipient-keys/$recipientID';
      final response = await dio.delete(path);
      log('removePublicGPGKey: ${response.statusCode}');
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeRecipient(String recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/recipients/$recipientID';
      final response = await dio.delete(path);
      log('removeRecipient: ${response.statusCode}');
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableReplyAndSend(String recipientId) async {
    try {
      final path = '$kUnEncodedBaseURL/allowed-recipients/$recipientId';
      final response = await dio.delete(path);
      log('disableReplyAndSend: ${response.statusCode}');
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }
}
