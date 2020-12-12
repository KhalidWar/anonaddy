import 'dart:convert';

import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final apiServiceProvider =
    ChangeNotifierProvider.autoDispose<APIService>((ref) => APIService());

class APIService extends ChangeNotifier {
  static const String _baseURL = 'https://app.anonaddy.com/api/v1';
  static const String _accountDetailsURL = 'account-details';
  static const String _activeAliasURL = 'active-aliases';
  static const String _aliasesURL = 'aliases';

  final _headers = <String, String>{
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Accept": "application/json",
  };

  String _accessTokenValue;

  Future<String> _getAccessToken() async {
    if (_accessTokenValue == null || _accessTokenValue.isEmpty) {
      final sharedPreferences = await SharedPreferences.getInstance();
      final tokenValue = sharedPreferences.getString('tokenKey');
      if (tokenValue == null || tokenValue.isEmpty) {
        return null;
      } else {
        return _accessTokenValue = tokenValue;
      }
    }
    return _accessTokenValue;
  }

  Future<String> validateAccessToken(String accessToken) async {
    _headers["Authorization"] = "Bearer $accessToken";

    final response = await http.get(
        Uri.encodeFull('$_baseURL/$_accountDetailsURL'),
        headers: _headers);

    return APIMessageHandler().getStatusCodeMessage(response.statusCode);
  }

  Future<UserModel> getUserData() async {
    try {
      String accessToken = await _getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.get(
          Uri.encodeFull('$_baseURL/$_accountDetailsURL'),
          headers: _headers);

      if (response.statusCode == 200) {
        print('getUserData ${response.statusCode}');
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        print('getUserData ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AliasModel> getAllAliasesData() async {
    try {
      String accessToken = await _getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.get(
          Uri.encodeFull('$_baseURL/$_aliasesURL?deleted=with'),
          headers: _headers);

      if (response.statusCode == 200) {
        print('getAllAliasesData ${response.statusCode}');
        return AliasModel.fromJson(jsonDecode(response.body));
      } else {
        print('getAllAliasesData ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> createNewAlias(String description) async {
    try {
      String accessToken = await _getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.post(Uri.encodeFull('$_baseURL/$_aliasesURL'),
          headers: _headers,
          body: json.encode({
            "domain": "anonaddy.me",
            "format": "uuid",
            "description": "$description",
          }));

      return APIMessageHandler().getStatusCodeMessage(response.statusCode);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> activateAlias({String aliasID}) async {
    try {
      String accessToken = await _getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.post(
        Uri.encodeFull('$_baseURL/$_activeAliasURL'),
        headers: _headers,
        body: json.encode({"id": "$aliasID"}),
      );

      if (response.statusCode == 200) {
        print('Network activateAlias ${response.statusCode}');
        return jsonDecode(response.body);
      } else {
        print('Network activateAlias ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> deactivateAlias({String aliasID}) async {
    try {
      String accessToken = await _getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.delete(
          Uri.encodeFull('$_baseURL/$_activeAliasURL/$aliasID'),
          headers: _headers);

      if (response.statusCode == 204) {
        print('Network deactivateAlias ${response.statusCode}');
        return response.body;
      } else {
        print('Network deactivateAlias ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> editDescription({String newDescription}) async {
    try {
      String accessToken = await _getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.patch(
          Uri.encodeFull('$_baseURL/$_aliasesURL/$newDescription'),
          headers: _headers,
          body: jsonEncode({"description": "$newDescription"}));

      if (response.statusCode == 200) {
        print('Network editDescription ${response.statusCode}');
        return response.body;
      } else {
        print('Network editDescription ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> deleteAlias(String aliasID) async {
    try {
      String accessToken = await _getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.delete(
          Uri.encodeFull('$_baseURL/$_aliasesURL/$aliasID'),
          headers: _headers);

      if (response.statusCode == 204) {
        print('Network deleteAlias ${response.statusCode}');
        return response.body;
      } else {
        print('Network deleteAlias ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> restoreAlias(String aliasID) async {
    try {
      String accessToken = await _getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.patch(
          Uri.encodeFull('$_baseURL/$_aliasesURL/$aliasID/restore'),
          headers: _headers);

      if (response.statusCode == 200) {
        print('Network restoreAlias ${response.statusCode}');
        return response.body;
      } else {
        print('Network restoreAlias ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AliasDataModel> getSpecificAliasData(String aliasID) async {
    final accessToken = await _getAccessToken();
    _headers["Authorization"] = "Bearer $accessToken";

    final response = await http.get(
        Uri.encodeFull('$_baseURL/$_aliasesURL/$aliasID'),
        headers: _headers);

    if (response.statusCode == 200) {
      final data = AliasDataModel.fromJsonData(jsonDecode(response.body));
      return data;
    } else {
      return null;
    }
  }
}
