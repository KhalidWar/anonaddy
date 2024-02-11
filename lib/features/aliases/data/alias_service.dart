import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/services/data_storage/alias_data_storage.dart';
import 'package:anonaddy/services/dio_client/dio_interceptors.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasServiceProvider = Provider<AliasService>((ref) {
  return AliasService(
    dio: ref.read(dioProvider),
    dataStorage: ref.read(aliasDataStorageProvider),
  );
});

class AliasService {
  const AliasService({
    required this.dio,
    required this.dataStorage,
  });
  final Dio dio;
  final AliasDataStorage dataStorage;

  Future<List<Alias>> fetchAvailableAliases() async {
    try {
      const path = '$kUnEncodedBaseURL/aliases';
      final params = {'with': 'recipients'};
      final response = await dio.get(path, queryParameters: params);
      log('fetchAvailableAliases: ${response.statusCode}');
      final aliases = response.data['data'] as List;
      dataStorage.saveAliases(aliases: aliases, isAvailableAliases: true);
      return aliases.map((alias) => Alias.fromJson(alias)).toList();
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.other) {
        final aliases = await dataStorage.loadAliases(isAvailableAliases: true);
        if (aliases != null) return aliases;
      }
      throw dioError.message;
    } catch (e) {
      throw 'Failed to fetch available aliases';
    }
  }

  Future<List<Alias>> fetchDeletedAliases() async {
    try {
      const path = '$kUnEncodedBaseURL/aliases';
      final params = {'deleted': 'only', 'with': 'recipients'};
      final response = await dio.get(path, queryParameters: params);
      log('fetchDeletedAliases: ${response.statusCode}');
      final aliases = response.data['data'] as List;
      dataStorage.saveAliases(aliases: aliases, isAvailableAliases: false);
      return aliases.map((alias) => Alias.fromJson(alias)).toList();
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.other) {
        final aliases =
            await dataStorage.loadAliases(isAvailableAliases: false);
        if (aliases != null) return aliases;
      }
      throw dioError.message;
    } catch (e) {
      throw 'Failed to fetch deleted aliases';
    }
  }

  Future<List<Alias>?> loadAvailableAliasesFromDisk() async {
    try {
      final availableAliases =
          await dataStorage.loadAliases(isAvailableAliases: true);
      return availableAliases;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Alias>?> loadDeletedAliasesFromDisk() async {
    try {
      final deletedAliases =
          await dataStorage.loadAliases(isAvailableAliases: false);
      return deletedAliases;
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> fetchSpecificAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/aliases/$aliasID';
      final response = await dio.get(path);
      log('getSpecificAlias: ${response.statusCode}');
      return Alias.fromJson(response.data['data']);
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.other) {
        final alias = await dataStorage.loadSpecificAlias(aliasID);
        if (alias != null) return alias;
      }
      throw dioError.message;
    } catch (e) {
      throw 'Failed to fetch alias';
    }
  }

  Future<Alias> createNewAlias({
    required String desc,
    required String localPart,
    required String domain,
    required String format,
    required List<String> recipients,
  }) async {
    try {
      const path = '$kUnEncodedBaseURL/aliases';
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
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> activateAlias(String aliasId) async {
    try {
      const path = '$kUnEncodedBaseURL/active-aliases';
      final data = json.encode({"id": aliasId});
      final response = await dio.post(path, data: data);
      final alias = Alias.fromJson(response.data['data']);
      log('activateAlias: ${response.statusCode}');
      return alias;
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateAlias(String aliasId) async {
    try {
      final path = '$kUnEncodedBaseURL/active-aliases/$aliasId';
      final response = await dio.delete(path);
      log('deactivateAlias: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> updateAliasDescription(String aliasID, String newDesc) async {
    try {
      final path = '$kUnEncodedBaseURL/aliases/$aliasID';
      final data = jsonEncode({"description": newDesc});
      final response = await dio.patch(path, data: data);
      log('updateAliasDescription: ${response.statusCode}');
      return Alias.fromJson(response.data['data']);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/aliases/$aliasID';
      final response = await dio.delete(path);
      log('deleteAlias: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> restoreAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/aliases/$aliasID/restore';
      final response = await dio.patch(path);
      log('restoreAlias: ${response.statusCode}');
      return Alias.fromJson(response.data['data']);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> updateAliasDefaultRecipient(
      String aliasID, List<String> recipientId) async {
    try {
      const path = '$kUnEncodedBaseURL/alias-recipients';
      final data =
          jsonEncode({"alias_id": aliasID, "recipient_ids": recipientId});
      final response = await dio.post(path, data: data);
      log('updateAliasDefaultRecipient: ${response.statusCode}');
      return Alias.fromJson(response.data['data']);
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgetAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/aliases/$aliasID/forget';
      final response = await dio.delete(path);
      log('forgetAlias: ${response.statusCode}');
    } on DioError catch (dioError) {
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  String generateSendFromAlias(String aliasEmail, String destinationEmail) {
    /// https://addy.io/help/sending-email-from-an-alias/
    final leftPartOfAlias = aliasEmail.split('@')[0];
    final rightPartOfAlias = aliasEmail.split('@')[1];
    final recipientEmail = destinationEmail.replaceAll('@', '=');
    final generatedAddress =
        '$leftPartOfAlias+$recipientEmail@$rightPartOfAlias';

    return generatedAddress;
  }
}
