import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginStateManager extends ChangeNotifier {
  LoginStateManager() {
    isLoading = false;
  }

  bool _isLoading;

  final _showToast = NicheMethod().showToast;

  bool get isLoading => _isLoading;
  set isLoading(bool toggle) {
    _isLoading = toggle;
    notifyListeners();
  }

  Future<void> login(BuildContext context, String accessToken,
      GlobalKey<FormState> formKey) async {
    if (formKey.currentState.validate()) {
      isLoading = true;
      await context
          .read(accessTokenServiceProvider)
          .validateAccessToken(accessToken)
          .then((value) async {
        if (value == 200) {
          await context
              .read(accessTokenServiceProvider)
              .saveAccessToken(accessToken);
          isLoading = false;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      }).catchError((error, stackTrace) {
        isLoading = false;
        _showToast(error.toString());
      });
    }
  }

  Future<void> selfHostLogin(
      BuildContext context,
      String instanceURL,
      String accessToken,
      GlobalKey<FormState> urlFormKey,
      GlobalKey<FormState> tokenFormKey) async {
    if (urlFormKey.currentState.validate() &&
        tokenFormKey.currentState.validate()) {
      isLoading = true;
      await context
          .read(accessTokenServiceProvider)
          .validateAccessToken(accessToken, instanceURL: instanceURL)
          .then((value) async {
        if (value == 200) {
          await context
              .read(accessTokenServiceProvider)
              .saveAccessToken(accessToken);
          isLoading = false;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      }).catchError((error, stackTrace) {
        isLoading = false;
        _showToast(error.toString());
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    await FlutterSecureStorage()
        .deleteAll()
        .whenComplete(() => Phoenix.rebirth(context));
  }

  Future<void> pasteFromClipboard(TextEditingController controller) async {
    final data = await Clipboard.getData('text/plain');
    if (data == null || data.text.isEmpty) {
      _showToast('Nothing to paste. Clipboard is empty.');
    } else {
      controller.clear();
      controller.text = data.text;
    }
  }
}
