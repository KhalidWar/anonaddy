import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/services/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIDataManager {
  static const String _baseURL = 'https://app.anonaddy.com/api/v1';
  static const String _accountDetailsURL = 'account-details';
  static const String _activeAliasURL = 'active-aliases';
  static const String _aliasesURL = 'aliases';
  String _accessTokenValue;

  Future _getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var tokenValue = sharedPreferences.getString('tokenKey');
    //todo implement error check for tokenValue
    _accessTokenValue = tokenValue;
  }

  Future<UserModel> fetchUserData() async {
    await _getAccessToken();
    Networking networking = Networking(
        url: '$_baseURL/$_accountDetailsURL', accessToken: _accessTokenValue);
    final response = await networking.getData();
    var data = UserModel.fromJson(response);
    return data;
  }

  Future<AliasModel> fetchAliasData() async {
    await _getAccessToken();
    Networking networking = Networking(
        url: '$_baseURL/$_aliasesURL', accessToken: _accessTokenValue);
    final response = await networking.getData();
    var data = AliasModel.fromJson(response);
    return data;
  }

  Future createNewAlias({String description}) async {
    Networking networking = Networking(
        url: '$_baseURL/$_aliasesURL', accessToken: _accessTokenValue);
    var data = await networking.postData(description: description);
    return data;
  }

  Future activateAlias({String aliasID}) async {
    Networking networking = Networking(
        url: '$_baseURL/$_activeAliasURL', accessToken: _accessTokenValue);
    var data = await networking.activateAlias(aliasID: aliasID);
    return data;
  }

  Future deactivateAlias({String aliasID}) async {
    Networking networking = Networking(
        url: '$_baseURL/$_activeAliasURL/$aliasID',
        accessToken: _accessTokenValue);
    var data = await networking.deactivateAlias();
    return data;
  }

  Future editDescription({String newDescription}) async {
    Networking networking = Networking(
        url: '$_baseURL/$_aliasesURL/$newDescription',
        accessToken: _accessTokenValue);
    var data = await networking.editDescription(newDescription: newDescription);
    return data;
  }

  Future deleteAlias({String aliasID}) async {
    Networking networking = Networking(
        url: '$_baseURL/$_aliasesURL/$aliasID', accessToken: _accessTokenValue);
    var data = networking.deleteAlias();
    return data;
  }
}
