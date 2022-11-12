import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/models/username/username.dart';
import 'package:anonaddy/services/data_storage/usernames_data_storage.dart';
import 'package:anonaddy/services/dio_client/dio_interceptors.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameServiceProvider = Provider<UsernameService>((ref) {
  return UsernameService(
    dio: ref.read(dioProvider),
    dataStorage: ref.read(usernameDataStorageProvider),
  );
});

class UsernameService {
  const UsernameService({
    required this.dio,
    required this.dataStorage,
  });
  final Dio dio;
  final UsernamesDataStorage dataStorage;

  Future<List<Username>> fetchUsernames() async {
    try {
      const path = '$kUnEncodedBaseURL/usernames';
      final response = await dio.get(path);
      log('getUsernames: ${response.statusCode}');
      dataStorage.saveData(response.data);
      final usernames = response.data['data'] as List;
      return usernames.map((username) => Username.fromJson(username)).toList();
    } on DioError catch (dioError) {
      /// If offline, load offline data.
      if (dioError.type == DioErrorType.other) {
        final usernames = await dataStorage.loadData();
        return usernames;
      }
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Username> fetchSpecificUsername(String usernameId) async {
    try {
      final path = '$kUnEncodedBaseURL/usernames/$usernameId';
      final response = await dio.get(path);
      log('getSpecificUsername: ${response.statusCode}');
      final username = response.data['data'];
      return Username.fromJson(username);
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.other) {
        final username = await dataStorage.loadSpecificUsername(usernameId);
        return username;
      }
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Username>> loadUsernameFromDisk() async {
    try {
      return await dataStorage.loadData();
    } catch (error) {
      rethrow;
    }
  }

  Future<Username> addNewUsername(String newUsername) async {
    try {
      const path = '$kUnEncodedBaseURL/usernames';
      final data = json.encode({"username": newUsername});
      final response = await dio.post(path, data: data);
      log('addNewUsername: ${response.statusCode}');
      final username = response.data['data'];
      return Username.fromJson(username);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Username> updateUsernameDescription(
      String usernameID, String description) async {
    try {
      final path = '$kUnEncodedBaseURL/usernames/$usernameID';
      final data = jsonEncode({"description": description});
      final response = await dio.patch(path, data: data);
      log('updateUsernameDescription: ${response.statusCode}');
      final username = response.data['data'];
      return Username.fromJson(username);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUsername(String usernameID) async {
    try {
      final path = '$kUnEncodedBaseURL/usernames/$usernameID';
      final response = await dio.delete(path);
      log('deleteUsername: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Username> updateDefaultRecipient(
      String usernameID, String recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/usernames/$usernameID/default-recipient';
      final data = jsonEncode({"default_recipient": recipientID});
      final response = await dio.patch(path, data: data);
      log('updateDefaultRecipient: ${response.statusCode}');
      final username = response.data['data'];
      return Username.fromJson(username);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Username> activateUsername(String usernameID) async {
    try {
      const path = '$kUnEncodedBaseURL/active-usernames';
      final data = json.encode({"id": usernameID});
      final response = await dio.post(path, data: data);
      log('activateUsername: ${response.statusCode}');
      final username = response.data['data'];
      return Username.fromJson(username);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateUsername(String usernameID) async {
    try {
      final path = '$kUnEncodedBaseURL/active-usernames/$usernameID';
      final response = await dio.delete(path);
      log('deactivateUsername: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Username> activateCatchAll(String usernameID) async {
    try {
      const path = '$kUnEncodedBaseURL/catch-all-usernames';
      final data = json.encode({"id": usernameID});
      final response = await dio.post(path, data: data);
      log('activateCatchAll: ${response.statusCode}');
      final username = response.data['data'];
      return Username.fromJson(username);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateCatchAll(String usernameID) async {
    try {
      final path = '$kUnEncodedBaseURL/catch-all-usernames/$usernameID';
      final response = await dio.delete(path);
      log('deactivateCatchAll: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }
}
