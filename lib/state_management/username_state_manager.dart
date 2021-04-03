import 'package:anonaddy/models/username/username_data_model.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UsernameStateManager extends ChangeNotifier {
  UsernameStateManager() {
    activeSwitchLoading = false;
    catchAllSwitchLoading = false;
  }

  UsernameDataModel usernameModel;

  bool _activeSwitchValue;
  bool _catchAllSwitchValue;
  bool _activeSwitchLoading;
  bool _catchAllSwitchLoading;

  final usernameFormKey = GlobalKey<FormState>();

  get activeSwitchValue => _activeSwitchValue;
  get catchAllSwitchValue => _catchAllSwitchValue;
  get activeSwitchLoading => _activeSwitchLoading;
  get catchAllSwitchLoading => _catchAllSwitchLoading;

  set activeSwitchValue(bool input) {
    _activeSwitchValue = input;
    notifyListeners();
  }

  set catchAllSwitchValue(bool input) {
    _catchAllSwitchValue = input;
    notifyListeners();
  }

  set activeSwitchLoading(bool input) {
    _activeSwitchLoading = input;
    notifyListeners();
  }

  set catchAllSwitchLoading(bool input) {
    _catchAllSwitchLoading = input;
    notifyListeners();
  }

  Future<void> toggleActiveAlias(
      BuildContext context, String usernameID) async {
    final usernameProvider = context.read(usernameServiceProvider);
    activeSwitchLoading = true;
    if (_activeSwitchValue) {
      await usernameProvider.deactivateUsername(usernameID).then((value) {
        showToast('Username Deactivated Successfully!');
        activeSwitchValue = false;
      }).catchError((error) {
        showToast(error.toString());
      });
      activeSwitchLoading = false;
    } else {
      await usernameProvider.activateUsername(usernameID).then((value) {
        showToast('Username Activated Successfully!');
        activeSwitchValue = true;
      }).catchError((error) {
        showToast(error.toString());
      });
      activeSwitchLoading = false;
    }
  }

  Future<void> toggleCatchAllAlias(
      BuildContext context, String usernameID) async {
    final usernameProvider = context.read(usernameServiceProvider);
    catchAllSwitchLoading = true;
    if (_catchAllSwitchValue) {
      await usernameProvider.deactivateCatchAll(usernameID).then((value) {
        showToast('Catch All Deactivated Successfully!');
        catchAllSwitchValue = false;
      }).catchError((error) {
        showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    } else {
      await usernameProvider.activateCatchAll(usernameID).then((value) {
        showToast('Catch All Activated Successfully!');
        catchAllSwitchValue = true;
      }).catchError((error) {
        showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    }
  }

  Future<void> createNewUsername(BuildContext context, String username) async {
    if (usernameFormKey.currentState.validate()) {
      await context
          .read(usernameServiceProvider)
          .createNewUsername(username)
          .then((value) {
        print(value);
        showToast('Username added successfully!');
        Navigator.pop(context);
      }).catchError((error) {
        showToast(error.toString());
      });
    }
  }

  Future<void> deleteUsername(BuildContext context, String usernameID) async {
    Navigator.pop(context);
    await context
        .read(usernameServiceProvider)
        .deleteUsername(usernameID)
        .then((value) {
      Navigator.pop(context);
      showToast('Username deleted successfully!');
    }).catchError((error) {
      showToast(error.toString());
    });
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
