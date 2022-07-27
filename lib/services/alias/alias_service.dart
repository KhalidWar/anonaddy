import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasServiceProvider = Provider<AliasService>((ref) {
  return AliasService(dio: ref.read(dioProvider));
});

class AliasService {
  const AliasService({required this.dio});
  final Dio dio;

  Future<List<Alias>> getAliases(String? deleted) async {
    try {
      const path = '$kUnEncodedBaseURL/$kAliasesURL';
      final params = {'deleted': deleted};
      final response = await dio.get(path, queryParameters: params);
      log('getAllAliases: ${response.statusCode}');
      final aliases = response.data['data'] as List;
      return aliases.map((alias) => Alias.fromJson(alias)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Alias>> getAvailableAliases() async {
    try {
      const path = '$kUnEncodedBaseURL/$kAliasesURL';
      final response = await dio.get(path);
      log('getAvailableAliases: ${response.statusCode}');
      final aliases = response.data['data'] as List;
      return aliases.map((alias) => Alias.fromJson(alias)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Alias>> getDeletedAliases() async {
    try {
      const path = '$kUnEncodedBaseURL/$kAliasesURL';
      final params = {'deleted': 'only'};
      final response = await dio.get(path, queryParameters: params);
      log('getDeletedAliases: ${response.statusCode}');
      final aliases = response.data['data'] as List;
      return aliases.map((alias) => Alias.fromJson(alias)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> getSpecificAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/$kAliasesURL/$aliasID';
      final response = await dio.get(path);
      log('getSpecificAlias: ${response.statusCode}');
      return Alias.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> createNewAlias({
    required String desc,
    localPart,
    domain,
    format,
    required List<String> recipients,
  }) async {
    try {
      const path = '$kUnEncodedBaseURL/$kAliasesURL';
      final data = json.encode({
        "domain": domain,
        "format": format,
        "description": desc,
        "recipient_ids": recipients,
        if (format == 'custom') "local_part": localPart,
      });
      final response = await dio.post(path, data: data);
      log('createNewAlias: ${response.statusCode}');
      return Alias.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> activateAlias(String aliasId) async {
    try {
      const path = '$kUnEncodedBaseURL/$kActiveAliasURL';
      final data = json.encode({"id": aliasId});
      final response = await dio.post(path, data: data);
      final alias = Alias.fromJson(response.data['data']);
      log('activateAlias: ${response.statusCode}');
      return alias;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateAlias(String aliasId) async {
    try {
      final path = '$kUnEncodedBaseURL/$kActiveAliasURL/$aliasId';
      final response = await dio.delete(path);
      log('deactivateAlias: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> updateAliasDescription(String aliasID, String newDesc) async {
    try {
      final path = '$kUnEncodedBaseURL/$kAliasesURL/$aliasID';
      final data = jsonEncode({"description": newDesc});
      final response = await dio.patch(path, data: data);
      log('updateAliasDescription: ${response.statusCode}');
      return Alias.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/$kAliasesURL/$aliasID';
      final response = await dio.delete(path);
      log('deleteAlias: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> restoreAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/$kAliasesURL/$aliasID/restore';
      final response = await dio.patch(path);
      log('restoreAlias: ${response.statusCode}');
      return Alias.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> updateAliasDefaultRecipient(
      String aliasID, List<String> recipientId) async {
    try {
      const path = '$kUnEncodedBaseURL/$kAliasURL-$kRecipientsURL';
      final data =
          jsonEncode({"alias_id": aliasID, "recipient_ids": recipientId});
      final response = await dio.post(path, data: data);
      log('updateAliasDefaultRecipient: ${response.statusCode}');
      return Alias.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgetAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/$kAliasesURL/$aliasID/$kForgetURL';
      final response = await dio.delete(path);
      log('forgetAlias: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }
}
