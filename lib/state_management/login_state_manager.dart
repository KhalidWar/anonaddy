import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginStateManager extends ChangeNotifier {
  LoginStateManager() {
    _isLoading = false;
  }

  bool _isLoading;

  bool get isLoading => _isLoading;
  set isLoading(bool toggle) {
    _isLoading = toggle;
    notifyListeners();
  }

  void _showError(String input) {
    Fluttertoast.showToast(
      msg: input,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[600],
    );
  }

  void pasteFromClipboard(TextEditingController _textEditingController) async {
    ClipboardData data = await Clipboard.getData('text/plain');
    if (data == null || data.text.isEmpty) {
      _showError('Nothing to paste. Clipboard is empty.');
    } else {
      _textEditingController.clear();
      _textEditingController.text = data.text;
    }
  }

  void login(
      BuildContext context, String input, GlobalKey<FormState> formKey) async {
    if (formKey.currentState.validate()) {
      isLoading = true;
      await context
          .read(accessTokenServiceProvider)
          .validateAccessToken(input)
          .then((value) async {
        if (value == 200) {
          await context.read(accessTokenServiceProvider).saveAccessToken(input);
          isLoading = false;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          isLoading = false;
          _showError('$value');
        }
      }).catchError((error, stackTrade) {
        isLoading = false;
        _showError('$error');
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    await FlutterSecureStorage().deleteAll();
  }
}
