import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/username/username_data_model.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class UsernameService {
  final _accessTokenService = AccessTokenService();

  Future<UsernameModel> getUsernameData(OfflineData offlineData) async {
    final accessToken = await _accessTokenService.getAccessToken();

    try {
      final response = await http.get(
        Uri.encodeFull('$kBaseURL/$kUsernamesURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getUsernameData ${response.statusCode}');
        await offlineData.writeUsernameOfflineData(response.body);
        return UsernameModel.fromJson(jsonDecode(response.body));
      } else {
        print('getUsernameData ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } on SocketException {
      final securedData = await offlineData.readUsernameOfflineData();
      return UsernameModel.fromJson(jsonDecode(securedData));
    } catch (e) {
      throw e;
    }
  }

  Future<UsernameModel> createNewUsername(String username) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kUsernamesURL'),
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
        return UsernameModel.fromJson(jsonDecode(response.body));
      } else {
        print("createNewUsername ${response.statusCode}");
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UsernameDataModel> editUsernameDescription(
      String usernameID, String description) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.patch(
        Uri.encodeFull('$kBaseURL/$kUsernamesURL/$usernameID'),
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
        return UsernameDataModel.fromJsonData(jsonDecode(response.body));
      } else {
        print("editUsernameDescription ${response.statusCode}");
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deleteUsername(String usernameID) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.delete(
          Uri.encodeFull('$kBaseURL/$kUsernamesURL/$usernameID'),
          headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken",
          });

      if (response.statusCode == 204) {
        print("deleteUsername ${response.statusCode}");
        return 204;
      } else {
        print("deleteUsername ${response.statusCode}");
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future activateUsername(String usernameID) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kActiveUsernamesURL'),
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
        return 200;
      } else {
        print("activateUsername ${response.statusCode}");
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deactivateUsername(String usernameID) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.delete(
          Uri.encodeFull('$kBaseURL/$kActiveUsernamesURL/$usernameID'),
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
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future activateCatchAll(String usernameID) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kCatchAllUsernameURL'),
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
        return 200;
      } else {
        print("activateCatchAll ${response.statusCode}");
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deactivateCatchAll(String usernameID) async {
    final accessToken = await _accessTokenService.getAccessToken();
    try {
      final response = await http.delete(
          Uri.encodeFull('$kBaseURL/$kCatchAllUsernameURL/$usernameID'),
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
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
