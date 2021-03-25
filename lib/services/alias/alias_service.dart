import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/services/offline_data/offline_data.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../access_token/access_token_service.dart';

class AliasService {
  final _accessTokenService = AccessTokenService();

  Future<AliasModel> getAllAliasesData() async {
    final accessToken = await _accessTokenService.getAccessToken();
    final offlineData = OfflineData();

    try {
      final response = await http.get(
        Uri.encodeFull('$kBaseURL/$kAliasesURL?deleted=with'),
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

  Future<AliasDataModel> createNewAlias(
      String desc, String domain, String format, String localPart) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kAliasesURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({
          "domain": "$domain",
          "format": "$format",
          "description": "$desc",
          if (format == 'custom') "local_part": "$localPart",
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
        Uri.encodeFull('$kBaseURL/$kActiveAliasURL'),
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
        Uri.encodeFull('$kBaseURL/$kActiveAliasURL/$aliasID'),
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
        Uri.encodeFull('$kBaseURL/$kAliasesURL/$aliasID'),
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
        Uri.encodeFull('$kBaseURL/$kAliasesURL/$aliasID'),
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

  Future restoreAlias(String aliasID) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.patch(
        Uri.encodeFull('$kBaseURL/$kAliasesURL/$aliasID/restore'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('Network restoreAlias ${response.statusCode}');
        return 200;
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
        Uri.encodeFull('$kBaseURL/$kAliasURL-$kRecipientsURL'),
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
}
