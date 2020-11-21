import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

final accessTokenServiceProvider =
    ChangeNotifierProvider((ref) => AccessTokenService());

class AccessTokenService extends ChangeNotifier {
  SharedPreferences _sharedPreferences;

  Future _initSharedPref() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future saveAccessToken(String input) async {
    await _initSharedPref();
    _sharedPreferences.setString('tokenKey', input);
  }

  Future<String> getAccessToken() async {
    await _initSharedPref();
    String tokenValue = _sharedPreferences.getString('tokenKey');
    return tokenValue;
  }

  Future removeAccessToken() async {
    await _initSharedPref();
    _sharedPreferences.remove('tokenKey');
  }
}
