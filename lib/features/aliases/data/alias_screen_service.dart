import 'package:anonaddy/common/constants/data_storage_keys.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/flutter_secure_storage.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasScreenServiceProvider =
    Provider.autoDispose<AliasScreenService>((ref) {
  return AliasScreenService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorage),
  );
});

class AliasScreenService extends BaseService {
  const AliasScreenService({
    required super.dio,
    required super.secureStorage,
    super.storageKey = '',
    super.parentStorageKey = DataStorageKeys.aliasesKey,
  });

  Future<Alias> fetchSpecificAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/aliases/$aliasID';
      final response = await get(path, childId: aliasID);
      return Alias.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> activateAlias(String aliasId) async {
    try {
      const path = '$kUnEncodedBaseURL/active-aliases';
      final response = await post(path, data: {"id": aliasId});
      return Alias.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateAlias(String aliasId) async {
    try {
      final path = '$kUnEncodedBaseURL/active-aliases/$aliasId';
      await delete(path);
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> updateAliasDescription(String aliasID, String newDesc) async {
    try {
      final path = '$kUnEncodedBaseURL/aliases/$aliasID';
      final response = await patch(path, data: {"description": newDesc});
      return Alias.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/aliases/$aliasID';
      await delete(path);
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> restoreAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/aliases/$aliasID/restore';
      final response = await patch(path, data: {});
      return Alias.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgetAlias(String aliasID) async {
    try {
      final path = '$kUnEncodedBaseURL/aliases/$aliasID/forget';
      await delete(path);
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
