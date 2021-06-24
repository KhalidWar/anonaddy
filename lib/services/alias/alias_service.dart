import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

import '../access_token/access_token_service.dart';

class AliasService {
  final _accessTokenService = AccessTokenService();

  Future<AliasModel> getAllAliasesData(OfflineData offlineData) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.get(
        Uri.https(kAuthorityURL, '$kUnEncodedBaseURL/$kAliasesURL',
            {'deleted': 'with'}),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getAllAliasesData ${response.statusCode}');
        await offlineData.writeAliasOfflineData(response.body);
        return AliasModel.fromJson(jsonDecode(response.body));
      } else {
        print('getAllAliasesData ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } on SocketException {
      final securedData = await offlineData.readAliasOfflineData();
      return AliasModel.fromJson(jsonDecode(securedData));
    } catch (e) {
      throw e;
    }
  }

  Future<AliasDataModel> createNewAlias(String desc, String domain,
      String format, String localPart, List<String> recipients) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.post(
        Uri.https(kAuthorityURL, '$kUnEncodedBaseURL/$kAliasesURL'),
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
        print("createNewAlias ${response.statusCode}");
        return AliasDataModel.fromJsonData(jsonDecode(response.body));
      } else {
        print("createNewAlias ${response.statusCode}");
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future activateAlias(String aliasID) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.post(
        Uri.https(kAuthorityURL, '$kUnEncodedBaseURL/$kActiveAliasURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({"id": "$aliasID"}),
      );

      if (response.statusCode == 200) {
        print('Network activateAlias ${response.statusCode}');
        return 200;
      } else {
        print('Network activateAlias ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deactivateAlias(String aliasID) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.delete(
        Uri.https(
            kAuthorityURL, '$kUnEncodedBaseURL/$kActiveAliasURL/$aliasID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        print('Network deactivateAlias ${response.statusCode}');
        return 204;
      } else {
        print('Network deactivateAlias ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<AliasDataModel> editAliasDescription(
      String aliasID, String newDesc) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.patch(
        Uri.https(kAuthorityURL, '$kUnEncodedBaseURL/$kAliasesURL/$aliasID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"description": "$newDesc"}),
      );

      if (response.statusCode == 200) {
        print('Network editDescription ${response.statusCode}');
        return AliasDataModel.fromJsonData(jsonDecode(response.body));
      } else {
        print('Network editDescription ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deleteAlias(String aliasID) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.delete(
        Uri.https(kAuthorityURL, '$kUnEncodedBaseURL/$kAliasesURL/$aliasID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        print('Network deleteAlias ${response.statusCode}');
        return 204;
      } else {
        print('Network deleteAlias ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<AliasDataModel> restoreAlias(String aliasID) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.patch(
        Uri.https(
            kAuthorityURL, '$kUnEncodedBaseURL/$kAliasesURL/$aliasID/restore'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('Network restoreAlias ${response.statusCode}');
        return AliasDataModel.fromJsonData(jsonDecode(response.body));
      } else {
        print('Network restoreAlias ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<AliasDataModel> updateAliasDefaultRecipient(
      String aliasID, List<String> recipients) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.post(
        Uri.https(
            kAuthorityURL, '$kUnEncodedBaseURL/$kAliasURL-$kRecipientsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"alias_id": aliasID, "recipient_ids": recipients}),
      );

      if (response.statusCode == 200) {
        print('editAliasRecipient ${response.statusCode}');
        return AliasDataModel.fromJsonData(jsonDecode(response.body));
      } else {
        print('editAliasRecipient ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future forgetAlias(String aliasID) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.delete(
        Uri.https(kAuthorityURL,
            '$kUnEncodedBaseURL/$kAliasesURL/$aliasID/$kForgetURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        print('forgetAlias ${response.statusCode}');
        return 204;
      } else {
        print('forgetAlias ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
