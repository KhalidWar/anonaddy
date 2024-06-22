import 'dart:async';

import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/usernames/domain/username.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameServiceProvider = Provider.autoDispose<UsernameService>((ref) {
  return UsernameService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorageProvider),
  );
});

class UsernameService extends BaseService {
  const UsernameService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = DataStorageKeys.usernameKey,
  });

  Future<List<Username>> fetchUsernames() async {
    const path = '$kUnEncodedBaseURL/usernames';
    final response = await get(path);
    final usernames = response['data'] as List;
    return usernames.map((username) => Username.fromJson(username)).toList();
  }

  Future<Username> addNewUsername(String newUsername) async {
    const path = '$kUnEncodedBaseURL/usernames';
    final response = await post(path, data: {"username": newUsername});
    return Username.fromJson(response['data']);
  }

  Future<List<Username>?> loadCachedData() async {
    final recipientsData = await loadData();
    if (recipientsData == null) return null;

    final recipients = (recipientsData['data'] as List)
        .map((recipient) => Username.fromJson(recipient))
        .toList();
    return recipients;
  }
}
