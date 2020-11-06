import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/services/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  static const String _baseURL = 'https://app.anonaddy.com/api/v1';
  static const String _accountDetailsURL = 'account-details';
  static const String _activeAliasURL = 'active-aliases';
  static const String _aliasesURL = 'aliases';

  Future<String> _getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final tokenValue = sharedPreferences.getString('tokenKey');
    if (tokenValue == null || tokenValue.isEmpty) {
      return null;
    } else {
      return tokenValue;
    }
  }

  Future<UserModel> fetchUserData() async {
    try {
      String _accessTokenValue = await _getAccessToken();
      NetworkService accountDetails = NetworkService(
          url: '$_baseURL/$_accountDetailsURL', accessToken: _accessTokenValue);
      final accountDetailsResponse = await accountDetails.getData();
      NetworkService aliasDetails = NetworkService(
          url: '$_baseURL/$_aliasesURL', accessToken: _accessTokenValue);
      final aliasDetailsResponse = await aliasDetails.getData();
      dynamic data = UserModel.fromJson(
        json: accountDetailsResponse,
        aliasJson: aliasDetailsResponse,
      );
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<UserModel> getUserDataStream() async* {
    yield await fetchUserData();
    while (true) {
      await Future.delayed(Duration(seconds: 3));
      yield await fetchUserData();
    }
  }

  Future createNewAlias({String description}) async {
    try {
      String _accessTokenValue = await _getAccessToken();
      NetworkService networking = NetworkService(
          url: '$_baseURL/$_aliasesURL', accessToken: _accessTokenValue);
      dynamic data = await networking.postData(description: description);
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future activateAlias({String aliasID}) async {
    try {
      String _accessTokenValue = await _getAccessToken();
      NetworkService networking = NetworkService(
          url: '$_baseURL/$_activeAliasURL', accessToken: _accessTokenValue);
      dynamic data = await networking.activateAlias(aliasID: aliasID);
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deactivateAlias({String aliasID}) async {
    try {
      String _accessTokenValue = await _getAccessToken();
      NetworkService networking = NetworkService(
          url: '$_baseURL/$_activeAliasURL/$aliasID',
          accessToken: _accessTokenValue);
      dynamic data = await networking.deactivateAlias();
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future editDescription({String newDescription}) async {
    try {
      String _accessTokenValue = await _getAccessToken();
      NetworkService networking = NetworkService(
          url: '$_baseURL/$_aliasesURL/$newDescription',
          accessToken: _accessTokenValue);
      dynamic data =
          await networking.editDescription(newDescription: newDescription);
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteAlias({String aliasID}) async {
    try {
      String _accessTokenValue = await _getAccessToken();
      NetworkService networking = NetworkService(
          url: '$_baseURL/$_aliasesURL/$aliasID',
          accessToken: _accessTokenValue);
      dynamic data = await networking.deleteAlias();
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
