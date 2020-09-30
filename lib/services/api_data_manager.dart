import 'dart:collection';

import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/services/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIDataManager {
  String baseURL = 'https://app.anonaddy.com/api/v1';
  String accountDetailsURL = 'account-details';
  String activeAliasURL = 'active-aliases';
  String aliasesURL = 'aliases';
  String accessTokenValue;

  List<AliasModel> _aliasList = [];
  UnmodifiableListView<AliasModel> get aliasList {
    return UnmodifiableListView(_aliasList);
  }

  Future _getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var getTokenValue = sharedPreferences.getString('tokenKey');
    accessTokenValue = getTokenValue;
  }

  Future<UserModel> fetchUserData() async {
    await _getAccessToken();
    Networking networking = Networking(
        url: '$baseURL/$accountDetailsURL', accessToken: accessTokenValue);
    final response = await networking.getData();
    var data = UserModel.fromJson(response);
    return data;
  }

  Future<AliasModel> fetchAliasData() async {
    await _getAccessToken();
    Networking networking =
        Networking(url: '$baseURL/$aliasesURL', accessToken: accessTokenValue);
    final response = await networking.getData();
    var data = AliasModel.fromJson(response);
    return data;
  }

  Future createNewAlias({String description}) async {
    Networking networking =
        Networking(url: '$baseURL/$aliasesURL', accessToken: accessTokenValue);
    var data = await networking.postData(description: description);
    return data;
  }

  Future activateAlias({String aliasID}) async {
    Networking networking = Networking(
        url: '$baseURL/$activeAliasURL', accessToken: accessTokenValue);
    var data = await networking.activateAlias(aliasID: aliasID);
    return data;
  }

  Future deactivateAlias({String aliasID}) async {
    Networking networking = Networking(
        url: '$baseURL/$activeAliasURL/$aliasID',
        accessToken: accessTokenValue);
    var data = await networking.deactivateAlias();
    return data;
  }

  Future editDescription({String newDescription}) async {
    Networking networking = Networking(
        url: '$baseURL/$aliasesURL/$newDescription',
        accessToken: accessTokenValue);
    var data = await networking.editDescription(newDescription: newDescription);
    return data;
  }

  Future deleteAlias({String aliasID}) async {
    Networking networking = Networking(
        url: '$baseURL/$aliasesURL/$aliasID', accessToken: accessTokenValue);
    var data = networking.deleteAlias();
    return data;
  }
}
