import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/services/network_service.dart';
import 'package:anonaddy/services/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final apiServiceProvider =
    ChangeNotifierProvider.autoDispose<APIService>((ref) => APIService());

class APIService extends ChangeNotifier {
  static const String _baseURL = 'https://app.anonaddy.com/api/v1';
  static const String _accountDetailsURL = 'account-details';
  static const String _activeAliasURL = 'active-aliases';
  static const String _aliasesURL = 'aliases';

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

  Stream<UserModel> getUserStream() async* {
    yield await _fetchUserData();
    while (true) {
      await Future.delayed(Duration(seconds: 3));
      yield await _fetchUserData();
    }
  }

  Future<UserModel> _fetchUserData() async {
    try {
      String _accessTokenValue = await _getAccessToken();
      final response = await serviceLocator<NetworkService>().getData(
          url: '$_baseURL/$_accountDetailsURL', accessToken: _accessTokenValue);
      return UserModel.fromJson(response);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<AliasModel> getAliasStream() async* {
    yield await _fetchAliasData();
    while (true) {
      await Future.delayed(Duration(seconds: 3));
      yield await _fetchAliasData();
    }
  }

  Future<AliasModel> _fetchAliasData() async {
    try {
      String _accessTokenValue = await _getAccessToken();
      final response = await serviceLocator<NetworkService>().getData(
          url: '$_baseURL/$_aliasesURL', accessToken: _accessTokenValue);
      return AliasModel.fromJson(response);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future createNewAlias({String description}) async {
    try {
      String _accessTokenValue = await _getAccessToken();
      dynamic data = await serviceLocator<NetworkService>().postData(
        description: description,
        url: '$_baseURL/$_aliasesURL',
        accessToken: _accessTokenValue,
      );
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future activateAlias({String aliasID}) async {
    try {
      String _accessTokenValue = await _getAccessToken();
      dynamic data = await serviceLocator<NetworkService>().activateAlias(
          aliasID: aliasID,
          url: '$_baseURL/$_activeAliasURL',
          accessToken: _accessTokenValue);
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deactivateAlias({String aliasID}) async {
    try {
      String _accessTokenValue = await _getAccessToken();
      dynamic data = await serviceLocator<NetworkService>().deactivateAlias(
        url: '$_baseURL/$_activeAliasURL/$aliasID',
        accessToken: _accessTokenValue,
      );
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future editDescription({String newDescription}) async {
    try {
      String _accessTokenValue = await _getAccessToken();
      dynamic data = await serviceLocator<NetworkService>().editDescription(
        newDescription: newDescription,
        url: '$_baseURL/$_aliasesURL/$newDescription',
        accessToken: _accessTokenValue,
      );
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteAlias({String aliasID}) async {
    try {
      String _accessTokenValue = await _getAccessToken();
      dynamic data = await serviceLocator<NetworkService>().deleteAlias(
          url: '$_baseURL/$_aliasesURL/$aliasID',
          accessToken: _accessTokenValue);
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> validateAccessToken(String testAccessToken) async {
    final response = await serviceLocator<NetworkService>().getData(
        url: '$_baseURL/$_accountDetailsURL', accessToken: testAccessToken);
    if (response == null) {
      return false;
    } else {
      return true;
    }
  }
}
