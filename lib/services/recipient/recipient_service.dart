import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:http/http.dart' as http;

class RecipientService {
  const RecipientService(this.accessTokenService);
  final AccessTokenService accessTokenService;

  Future<List<Recipient>> getAllRecipient() async {
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
        log('getAllRecipient ${response.statusCode}');
        final decodedData = jsonDecode(response.body)['data'];
        return (decodedData as List).map((recipient) {
          return Recipient.fromJson(recipient);
        }).toList();
      } else {
        log('getAllRecipient ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
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
        log('getSpecificAlias ${response.statusCode}');
        final recipient = jsonDecode(response.body)['data'];
        return Recipient.fromJson(recipient);
      } else {
        log('getSpecificAlias ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
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
        body: json.encode({"id": recipientID}),
      );

      if (response.statusCode == 200) {
        log('enableEncryption ${response.statusCode}');
        return Recipient.fromJson(jsonDecode(response.body)['data']);
      } else {
        log('enableEncryption ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
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
        log('disableEncryption ${response.statusCode}');
        return 204;
      } else {
        log('disableEncryption ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
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
        body: jsonEncode({"key_data": keyData}),
      );

      if (response.statusCode == 200) {
        log("addPublicGPGKey ${response.statusCode}");
        return Recipient.fromJson(jsonDecode(response.body)['data']);
      } else {
        log("addPublicGPGKey ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
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
        log('removePublicKey ${response.statusCode}');
        return 204;
      } else {
        log('removePublicKey ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
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
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 201) {
        log("addRecipient ${response.statusCode}");
        return Recipient.fromJson(jsonDecode(response.body)['data']);
      } else {
        log("addRecipient ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
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
        log('removeRecipient ${response.statusCode}');
        return 204;
      } else {
        log('removeRecipient ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
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
        body: json.encode({"recipient_id": recipientID}),
      );

      if (response.statusCode == 200) {
        log('sendVerificationEmail ${response.statusCode}');
        return 200;
      } else {
        log('sendVerificationEmail ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
