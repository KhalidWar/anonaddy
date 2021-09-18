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

  Future<void> login(BuildContext context, String accessToken,
      GlobalKey<FormState> tokenFormKey,
      {String? instanceURL, GlobalKey<FormState>? urlFormKey}) async {
    Future<void> login() async {
      if (tokenFormKey.currentState!.validate()) {
        isLoading = true;
        await accessTokenService
            .validateAccessToken(accessToken, instanceURL)
            .then((value) async {
          if (value == 200) {
            await accessTokenService.saveLoginCredentials(
                accessToken, instanceURL ?? kAuthorityURL);
            isLoading = false;
            if (instanceURL != null) Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              CustomPageRoute(HomeScreen()),
            );
          }
        }).catchError((error, stackTrace) {
          isLoading = false;
          showToast(error.toString());
        });
      }
    }

    if (urlFormKey == null) {
      login();
    } else {
      if (urlFormKey.currentState!.validate()) {
        login();
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    await secureStorage.deleteAll();
    await Phoenix.rebirth(context);
  }
}
