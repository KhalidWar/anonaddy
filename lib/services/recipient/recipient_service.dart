import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

class RecipientService {
  final _accessTokenService = AccessTokenService();

  Future<RecipientModel> getAllRecipient(OfflineData offlineData) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.get(
        Uri.encodeFull('$kBaseURL/$kRecipientsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getAllRecipient ${response.statusCode}');
        await offlineData.writeRecipientsOfflineData(response.body);
        return RecipientModel.fromJson(jsonDecode(response.body));
      } else {
        print('getAllRecipient ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } on SocketException {
      final securedData = await offlineData.readRecipientsOfflineData();
      return RecipientModel.fromJson(jsonDecode(securedData));
    } catch (e) {
      throw e;
    }
  }

  Future<RecipientDataModel> enableEncryption(String recipientID) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kEncryptedRecipient'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({"id": "$recipientID"}),
      );

      if (response.statusCode == 200) {
        print('enableEncryption ${response.statusCode}');
        return RecipientDataModel.fromJsonData(jsonDecode(response.body));
      } else {
        print('enableEncryption ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future disableEncryption(String recipientID) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.delete(
        Uri.encodeFull('$kBaseURL/$kEncryptedRecipient/$recipientID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      if (response.statusCode == 204) {
        print('disableEncryption ${response.statusCode}');
        return 204;
      } else {
        print('disableEncryption ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<RecipientDataModel> addPublicGPGKey(
      String recipientID, String keyData) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.patch(
          Uri.encodeFull('$kBaseURL/$kRecipientKeys/$recipientID'),
          headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken",
          },
          body: jsonEncode({"key_data": "$keyData"}));

      if (response.statusCode == 200) {
        print("addPublicGPGKey ${response.statusCode}");
        return RecipientDataModel.fromJsonData(jsonDecode(response.body));
      } else {
        print("addPublicGPGKey ${response.statusCode}");
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future removePublicGPGKey(String recipientID) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.delete(
          Uri.encodeFull('$kBaseURL/$kRecipientKeys/$recipientID'),
          headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken",
          });

      if (response.statusCode == 204) {
        print('removePublicKey ${response.statusCode}');
        return 204;
      } else {
        print('removePublicKey ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<RecipientDataModel> addRecipient(String email) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kRecipientsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"email": "$email"}),
      );

      if (response.statusCode == 201) {
        print("addRecipient ${response.statusCode}");
        return RecipientDataModel.fromJsonData(jsonDecode(response.body));
      } else {
        print("addRecipient ${response.statusCode}");
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future removeRecipient(String recipientID) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.delete(
          Uri.encodeFull('$kBaseURL/$kRecipientsURL/$recipientID'),
          headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken",
          });

      if (response.statusCode == 204) {
        print('removeRecipient ${response.statusCode}');
        return 204;
      } else {
        print('removeRecipient ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future sendVerificationEmail(String recipientID) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kRecipientsURL/email/resend'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({"recipient_id": "$recipientID"}),
      );

      if (response.statusCode == 200) {
        print('sendVerificationEmail ${response.statusCode}');
        return 200;
      } else {
        print('sendVerificationEmail ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
