import 'package:shared_preferences/shared_preferences.dart';

class AccessTokenService {
  SharedPreferences sharedPreferences;

  Future _initSharedPref() async {
    if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future saveAccessToken(String input) async {
    await _initSharedPref();
    sharedPreferences.setString('tokenKey', input);
  }

  Future<String> getAccessToken() async {
    await _initSharedPref();
    String tokenValue = sharedPreferences.getString('tokenKey');
    return tokenValue;
  }

  Future removeAccessToken() async {
    await _initSharedPref();
    sharedPreferences.remove('tokenKey');
  }
}
