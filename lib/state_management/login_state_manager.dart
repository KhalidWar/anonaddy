import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginStateManager extends ChangeNotifier {
  bool _isLoading = false;
  String _error;

  bool get isLoading => _isLoading;
  String get error => _error;

  void setIsLoading(bool toggle) {
    _isLoading = toggle;
    notifyListeners();
  }

  void setError(String input) {
    Fluttertoast.showToast(
      msg: input,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[600],
    );
    notifyListeners();
  }

  void pasteFromClipboard(TextEditingController _textEditingController) async {
    ClipboardData data = await Clipboard.getData('text/plain');
    if (data == null || data.text.isEmpty) {
      setError('Nothing to paste. Clipboard is empty.');
    } else {
      _textEditingController.clear();
      _textEditingController.text = data.text;
    }
  }

  void login(
      BuildContext context, String input, GlobalKey<FormState> formKey) async {
    setIsLoading(true);
    final accessTokenManager = context.read(accessTokenServiceProvider);
    if (formKey.currentState.validate()) {
      final isAccessTokenValid = await context
          .read(accessTokenServiceProvider)
          .validateAccessToken(input);
      if (isAccessTokenValid == '') {
        await accessTokenManager.saveAccessToken(input);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        setIsLoading(false);
        setError('$isAccessTokenValid');
      }
    } else {
      setIsLoading(false);
    }
  }

  void logout(BuildContext context) async {
    setIsLoading(false);
    await context.read(accessTokenServiceProvider).deleteAccessToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TokenLoginScreen()),
    );
  }
}
