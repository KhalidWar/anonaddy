import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginStateManager extends ChangeNotifier {
  LoginStateManager(
      {required this.accessTokenService,
      required this.secureStorage,
      required this.showToast}) {
    _isLoading = false;
  }

  final AccessTokenService accessTokenService;
  final FlutterSecureStorage secureStorage;
  final Function showToast;

  late bool _isLoading;

  bool get isLoading => _isLoading;
  set isLoading(bool toggle) {
    _isLoading = toggle;
    notifyListeners();
  }

  Future<void> login(BuildContext context, String url, String token) async {
    isLoading = true;
    try {
      final isTokenValid =
          await accessTokenService.validateAccessToken(url, token);

      if (isTokenValid) {
        await accessTokenService.saveLoginCredentials(url, token);
        isLoading = false;
        if (url != kAuthorityURL) Navigator.pop(context);
        Navigator.pushReplacement(context, CustomPageRoute(HomeScreen()));
      }
    } catch (error) {
      isLoading = false;
      showToast(error.toString());
    }
  }

  Future<void> logout(BuildContext context) async {
    await secureStorage.deleteAll();
    await Phoenix.rebirth(context);
  }
}
