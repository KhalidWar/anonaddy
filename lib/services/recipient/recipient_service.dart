import 'dart:convert';

import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

class RecipientService {
  final _headers = <String, String>{
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Accept": "application/json",
  };

  Future<RecipientModel> getAllRecipient() async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.get(
        Uri.encodeFull('$kBaseURL/$kRecipientsURL'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        print('getAllRecipient ${response.statusCode}');
        // print(jsonDecode(response.body));
        return RecipientModel.fromJson(jsonDecode(response.body));
      } else {
        print('getAllRecipient ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future enableEncryption(String recipientID) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kEncryptedRecipient'),
        headers: _headers,
        body: json.encode({"id": "$recipientID"}),
      );

      if (response.statusCode == 200) {
        print('enableEncryption ${response.statusCode}');
        return 200;
      } else {
        print('enableEncryption ${response.statusCode}');
        return APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future disableEncryption(String recipientID) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.delete(
        Uri.encodeFull('$kBaseURL/$kEncryptedRecipient/$recipientID'),
        headers: _headers,
      );
      if (response.statusCode == 204) {
        print('disableEncryption ${response.statusCode}');
        return 204;
      } else {
        print('disableEncryption ${response.statusCode}');
        return APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<RecipientDataModel> addPublicGPGKey(
      String recipientID, String keyData) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.patch(
          Uri.encodeFull('$kBaseURL/$kRecipientKeys/$recipientID'),
          headers: _headers,
          body: jsonEncode({"key_data": "$keyData"}));

      if (response.statusCode == 200) {
        print("addPublicGPGKey ${response.statusCode}");
        print(jsonDecode(response.body));
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
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.delete(
          Uri.encodeFull('$kBaseURL/$kRecipientKeys/$recipientID'),
          headers: _headers);

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

  Future sendVerificationEmail(String recipientID) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.post(
        Uri.encodeFull(
            'https://app.anonaddy.com/api/v1/recipients/email/resend'),
        headers: _headers,
        body: json.encode({"recipient_id": "$recipientID"}),
      );

      if (response.statusCode == 200) {
        print('sendVerificationEmail ${response.statusCode}');
        return 200;
      } else {
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
