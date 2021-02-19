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
      await context
          .read(usernameServiceProvider)
          .createNewUsername(username)
          .then((value) {
        if (value == 201) {
          showToast('Username added successfully!');
        } else {
          showToast('Failed to add username!');
        }
        textEditController.clear();
      });
      Navigator.pop(context);
    }
  }

  showToast(String input) {
    Fluttertoast.showToast(
      msg: input,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[600],
    );
  }
}
