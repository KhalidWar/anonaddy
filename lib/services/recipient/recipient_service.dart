import 'dart:convert';

import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:http/http.dart' as http;

class RecipientService {
  const RecipientService(this.accessTokenService);
  final AccessTokenService accessTokenService;

  Future<RecipientModel> getAllRecipient() async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kRecipientsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getAllRecipient ${response.statusCode}');
        return RecipientModel.fromJson(jsonDecode(response.body));
      } else {
        print('getAllRecipient ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Recipient> getSpecificRecipient(String recipientId) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(
            instanceURL,
            '$kUnEncodedBaseURL/$kRecipientsURL/$recipientId',
            {'deleted': 'with'}),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getSpecificAlias ${response.statusCode}');
        final recipient = jsonDecode(response.body)['data'];
        return Recipient.fromJson(recipient);
      } else {
        print('getSpecificAlias ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Recipient> enableEncryption(String recipientID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kEncryptedRecipient'),
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
        return Recipient.fromJson(jsonDecode(response.body)['data']);
      } else {
        print('enableEncryption ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future disableEncryption(String recipientID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
        Uri.https(instanceURL,
            '$kUnEncodedBaseURL/$kEncryptedRecipient/$recipientID'),
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
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Recipient> addPublicGPGKey(String recipientID, String keyData) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.patch(
        Uri.https(
            instanceURL, '$kUnEncodedBaseURL/$kRecipientKeys/$recipientID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"key_data": "$keyData"}),
      );

      if (response.statusCode == 200) {
        print("addPublicGPGKey ${response.statusCode}");
        return Recipient.fromJson(jsonDecode(response.body)['data']);
      } else {
        print("addPublicGPGKey ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future removePublicGPGKey(String recipientID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
        Uri.https(
            instanceURL, '$kUnEncodedBaseURL/$kRecipientKeys/$recipientID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        print('removePublicKey ${response.statusCode}');
        return 204;
      } else {
        print('removePublicKey ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Recipient> addRecipient(String email) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kRecipientsURL'),
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
        return Recipient.fromJson(jsonDecode(response.body)['data']);
      } else {
        print("addRecipient ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future removeRecipient(String recipientID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
        Uri.https(
            instanceURL, '$kUnEncodedBaseURL/$kRecipientsURL/$recipientID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        print('removeRecipient ${response.statusCode}');
        return 204;
      } else {
        print('removeRecipient ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future sendVerificationEmail(String recipientID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(
            instanceURL, '$kUnEncodedBaseURL/$kRecipientsURL/email/resend'),
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
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
