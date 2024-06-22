import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/usernames/domain/username.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameScreenServiceProvider =
    Provider.autoDispose<UsernameScreenService>((ref) {
  return UsernameScreenService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorageProvider),
  );
});

class UsernameScreenService extends BaseService {
  const UsernameScreenService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = '',
    super.parentStorageKey = DataStorageKeys.usernameKey,
  });

  Future<Username> fetchSpecificUsername(String usernameId) async {
    final path = '$kUnEncodedBaseURL/usernames/$usernameId';
    final response = await get(path, childId: usernameId);
    return Username.fromJson(response['data']);
  }

  Future<Username> updateUsernameDescription(
    String usernameID,
    String description,
  ) async {
    final path = '$kUnEncodedBaseURL/usernames/$usernameID';
    final response = await patch(path, data: {"description": description});
    return Username.fromJson(response['data']);
  }

  Future<void> deleteUsername(String usernameID) async {
    final path = '$kUnEncodedBaseURL/usernames/$usernameID';
    await delete(path);
  }

  Future<Username> updateDefaultRecipient(
    String usernameID,
    String? recipientID,
  ) async {
    final path = '$kUnEncodedBaseURL/usernames/$usernameID/default-recipient';
    final response =
        await patch(path, data: {"default_recipient": recipientID});
    return Username.fromJson(response['data']);
  }

  Future<Username> activateUsername(String usernameID) async {
    const path = '$kUnEncodedBaseURL/active-usernames';
    final response = await post(path, data: {"id": usernameID});
    return Username.fromJson(response['data']);
  }

  Future<void> deactivateUsername(String usernameID) async {
    final path = '$kUnEncodedBaseURL/active-usernames/$usernameID';
    await delete(path);
  }

  Future<Username> activateCatchAll(String usernameID) async {
    const path = '$kUnEncodedBaseURL/catch-all-usernames';
    final response = await post(path, data: {"id": usernameID});
    return Username.fromJson(response['data']);
  }

  Future<void> deactivateCatchAll(String usernameID) async {
    final path = '$kUnEncodedBaseURL/catch-all-usernames/$usernameID';
    await delete(path);
  }
}
