import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginStateManager extends ChangeNotifier {
  LoginStateManager() {
    isLoading = false;
  }

  bool _isLoading;

  bool get isLoading => _isLoading;
  set isLoading(bool toggle) {
    _isLoading = toggle;
    notifyListeners();
  }

  void login(BuildContext context, String accessToken,
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
      }).catchError((error, stackTrade) {
        isLoading = false;
        _showError(error.toString());
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    await FlutterSecureStorage()
        .deleteAll()
        .whenComplete(() => Phoenix.rebirth(context));
  }

  void pasteFromClipboard(TextEditingController controller) async {
    final data = await Clipboard.getData('text/plain');
    if (data == null || data.text.isEmpty) {
      _showError('Nothing to paste. Clipboard is empty.');
    } else {
      controller.clear();
      controller.text = data.text;
    }
  }

  void _showError(String input) {
    Fluttertoast.showToast(
      msg: input,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[600],
    );
  }
}
