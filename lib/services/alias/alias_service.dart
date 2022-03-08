import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class AliasService {
  const AliasService(this.accessTokenService, this.dio);
  final AccessTokenService accessTokenService;
  final Dio dio;

  Future<List<Alias>> getAllAliasesData(String? deleted) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasesURL',
            {'deleted': deleted}),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        log('getAllAliasesData ${response.statusCode}');
        final decodedData = jsonDecode(response.body)['data'];
        return (decodedData as List).map((alias) {
          return Alias.fromJson(alias);
        }).toList();
      } else {
        log('getAllAliasesData ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> getSpecificAlias(String aliasID) async {
    try {
      log(aliasID);
      final path = '$kUnEncodedBaseURL/$kAliasesURL/$aliasID';
      final response = await dio.get(path);
      final alias = Alias.fromJson(response.data['data']);
      log('getSpecificAlias ${response.statusCode}');

      return alias;
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> createNewAlias(
      {required String desc,
      localPart,
      domain,
      format,
      required List<String> recipients}) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasesURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({
          "domain": domain,
          "format": format,
          "description": desc,
          "recipient_ids": recipients,
          if (format == 'custom') "local_part": localPart,
        }),
      );

      if (response.statusCode == 201) {
        log("createNewAlias ${response.statusCode}");
        return Alias.fromJson(jsonDecode(response.body)['data']);
      } else {
        log("createNewAlias ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> activateAlias(String aliasId) async {
    try {
      const path = '$kUnEncodedBaseURL/$kActiveAliasURL';
      final response = await dio.post(
        path,
        data: json.encode({"id": aliasId}),
      );
      final alias = Alias.fromJson(response.data['data']);
      log('activateAlias: ' + response.statusCode.toString());
      return alias;
    } catch (e) {
      rethrow;
    }
  }

  Future deactivateAlias(String aliasId) async {
    try {
      final path = '$kUnEncodedBaseURL/$kActiveAliasURL/$aliasId';
      final response = await dio.delete(path);
      log('deactivateAlias: ' + response.statusCode.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> editAliasDescription(String aliasID, String newDesc) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.patch(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasesURL/$aliasID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"description": newDesc}),
      );

      if (response.statusCode == 200) {
        log('Network editDescription ${response.statusCode}');
        return Alias.fromJson(jsonDecode(response.body)['data']);
      } else {
        log('Network editDescription ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future deleteAlias(String aliasID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasesURL/$aliasID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        log('Network deleteAlias ${response.statusCode}');
        return 204;
      } else {
        log('Network deleteAlias ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> restoreAlias(String aliasID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.patch(
        Uri.https(
            instanceURL, '$kUnEncodedBaseURL/$kAliasesURL/$aliasID/restore'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        log('Network restoreAlias ${response.statusCode}');
        return Alias.fromJson(jsonDecode(response.body)['data']);
      } else {
        log('Network restoreAlias ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Alias> updateAliasDefaultRecipient(
      String aliasID, List<String> recipients) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasURL-$kRecipientsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "alias_id": aliasID,
          "recipient_ids": recipients,
        }),
      );

      if (response.statusCode == 200) {
        log('editAliasRecipient ${response.statusCode}');
        return Alias.fromJson(jsonDecode(response.body)['data']);
      } else {
        log('editAliasRecipient ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future forgetAlias(String aliasID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
        Uri.https(instanceURL,
            '$kUnEncodedBaseURL/$kAliasesURL/$aliasID/$kForgetURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        log('forgetAlias ${response.statusCode}');
        return 204;
      } else {
        log('forgetAlias ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
