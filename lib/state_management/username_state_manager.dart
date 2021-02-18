import 'package:anonaddy/state_management/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fluttertoast/fluttertoast.dart';

final usernameStateManagerProvider =
    ChangeNotifierProvider((ref) => UsernameStateManager());

class UsernameStateManager extends ChangeNotifier {
  final usernameFormKey = GlobalKey<FormState>();

  Future<void> createNewUsername(BuildContext context, String username,
      TextEditingController textEditController) async {
    if (usernameFormKey.currentState.validate()) {
      context
          .read(usernameServiceProvider)
          .createNewUsername(username)
          .then((value) {
        Navigator.pop(context);
        _showToast('Username Added Successfully!');
        textEditController.clear();
      }).catchError((error) {
        return _showToast(error.toString());
      });
    }
  }

  void _showToast(String input) {
    Fluttertoast.showToast(
      msg: input,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[600],
    );
  }
}
