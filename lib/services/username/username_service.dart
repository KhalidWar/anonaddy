import 'dart:async';
import 'dart:convert';

import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:http/http.dart' as http;

class UsernameService {
  const UsernameService(this.accessTokenService);
  final AccessTokenService accessTokenService;

  Future<UsernameModel> getUsernameData() async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kUsernamesURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getUsernameData ${response.statusCode}');
        return UsernameModel.fromJson(jsonDecode(response.body));
      } else {
        print('getUsernameData ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Username> getSpecificUsername(String usernameId) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kUsernamesURL/$usernameId'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getUsernameData ${response.statusCode}');
        return Username.fromJson(jsonDecode(response.body)['data']);
      } else {
        print('getUsernameData ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Username> createNewUsername(String username) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kUsernamesURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({"username": "$username"}),
      );

      if (response.statusCode == 201) {
        print("createNewUsername ${response.statusCode}");
        return Username.fromJson(jsonDecode(response.body)['data']);
      } else {
        print("createNewUsername ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Username> editUsernameDescription(
      String usernameID, String description) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.patch(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kUsernamesURL/$usernameID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"description": description}),
      );

      if (response.statusCode == 200) {
        print("editUsernameDescription ${response.statusCode}");
        return Username.fromJson(jsonDecode(response.body)['data']);
      } else {
        print("editUsernameDescription ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deleteUsername(String usernameID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kUsernamesURL/$usernameID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        print("deleteUsername ${response.statusCode}");
        return 204;
      } else {
        print("deleteUsername ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Username> updateDefaultRecipient(
      String usernameID, String recipientID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.patch(
        Uri.https(instanceURL,
            '$kUnEncodedBaseURL/$kUsernamesURL/$usernameID/$kDefaultRecipientURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"default_recipient": recipientID}),
      );

      if (response.statusCode == 200) {
        print("updateDefaultRecipient ${response.statusCode}");
        return Username.fromJson(jsonDecode(response.body)['data']);
      } else {
        print("updateDefaultRecipient ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Username> activateUsername(String usernameID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kActiveUsernamesURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({"id": "$usernameID"}),
      );

      if (response.statusCode == 200) {
        print("activateUsername ${response.statusCode}");
        return Username.fromJson(jsonDecode(response.body)['data']);
      } else {
        print("activateUsername ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deactivateUsername(String usernameID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
          Uri.https(instanceURL,
              '$kUnEncodedBaseURL/$kActiveUsernamesURL/$usernameID'),
          headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken",
          });

      if (response.statusCode == 204) {
        print("deactivateUsername ${response.statusCode}");
        return 204;
      } else {
        print("deactivateUsername ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Username> activateCatchAll(String usernameID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kCatchAllUsernameURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({"id": "$usernameID"}),
      );

      if (response.statusCode == 200) {
        print("activateCatchAll ${response.statusCode}");
        return Username.fromJson(jsonDecode(response.body)['data']);
      } else {
        print("activateCatchAll ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deactivateCatchAll(String usernameID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
          Uri.https(instanceURL,
              '$kUnEncodedBaseURL/$kCatchAllUsernameURL/$usernameID'),
          headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken",
          });

      if (response.statusCode == 204) {
        print("deactivateCatchAll ${response.statusCode}");
        return 204;
      } else {
        print("deactivateCatchAll ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
