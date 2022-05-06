import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/username/username.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameServiceProvider = Provider<UsernameService>((ref) {
  return UsernameService(dio: ref.read(dioProvider));
});

class UsernameService {
  const UsernameService({required this.dio});
  final Dio dio;

  Future<List<Username>> getUsernames() async {
    try {
      const path = '$kUnEncodedBaseURL/$kUsernamesURL';
      final response = await dio.get(path);
      log('getUsernames: ' + response.statusCode.toString());
      final usernames = response.data['data'] as List;
      return usernames.map((username) => Username.fromJson(username)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Username> getSpecificUsername(String usernameId) async {
    try {
      final path = '$kUnEncodedBaseURL/$kUsernamesURL/$usernameId';
      final response = await dio.get(path);
      log('getSpecificUsername: ' + response.statusCode.toString());
      final username = response.data['data'];
      return Username.fromJson(username);
    } catch (e) {
      rethrow;
    }
  }

  Future<Username> addNewUsername(String newUsername) async {
    try {
      const path = '$kUnEncodedBaseURL/$kUsernamesURL';
      final data = json.encode({"username": newUsername});
      final response = await dio.post(path, data: data);
      log('addNewUsername: ' + response.statusCode.toString());
      final username = response.data['data'];
      return Username.fromJson(username);
    } catch (e) {
      rethrow;
    }
  }

  Future<Username> updateUsernameDescription(
      String usernameID, String description) async {
    try {
      final path = '$kUnEncodedBaseURL/$kUsernamesURL/$usernameID';
      final data = jsonEncode({"description": description});
      final response = await dio.patch(path, data: data);
      log('updateUsernameDescription: ' + response.statusCode.toString());
      final username = response.data['data'];
      return Username.fromJson(username);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUsername(String usernameID) async {
    try {
      final path = '$kUnEncodedBaseURL/$kUsernamesURL/$usernameID';
      final response = await dio.delete(path);
      log('deleteUsername: ' + response.statusCode.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<Username> updateDefaultRecipient(
      String usernameID, String recipientID) async {
    try {
      final path =
          '$kUnEncodedBaseURL/$kUsernamesURL/$usernameID/$kDefaultRecipientURL';
      final data = jsonEncode({"default_recipient": recipientID});
      final response = await dio.patch(path, data: data);
      log('updateDefaultRecipient: ' + response.statusCode.toString());
      final username = response.data['data'];
      return Username.fromJson(username);
    } catch (e) {
      rethrow;
    }
  }

  Future<Username> activateUsername(String usernameID) async {
    try {
      const path = '$kUnEncodedBaseURL/$kActiveUsernamesURL';
      final data = json.encode({"id": usernameID});
      final response = await dio.post(path, data: data);
      log('activateUsername: ' + response.statusCode.toString());
      final username = response.data['data'];
      return Username.fromJson(username);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateUsername(String usernameID) async {
    try {
      final path = '$kUnEncodedBaseURL/$kActiveUsernamesURL/$usernameID';
      final response = await dio.delete(path);
      log('deactivateUsername: ' + response.statusCode.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<Username> activateCatchAll(String usernameID) async {
    try {
      const path = '$kUnEncodedBaseURL/$kCatchAllUsernameURL';
      final data = json.encode({"id": usernameID});
      final response = await dio.post(path, data: data);
      log('activateCatchAll: ' + response.statusCode.toString());
      final username = response.data['data'];
      return Username.fromJson(username);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateCatchAll(String usernameID) async {
    try {
      final path = '$kUnEncodedBaseURL/$kCatchAllUsernameURL/$usernameID';
      final response = await dio.delete(path);
      log('deactivateCatchAll: ' + response.statusCode.toString());
    } catch (e) {
      rethrow;
    }
  }
}
