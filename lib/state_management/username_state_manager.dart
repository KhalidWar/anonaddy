import 'package:anonaddy/models/username/username_data_model.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernameStateManager extends ChangeNotifier {
  UsernameStateManager() {
    activeSwitchLoading = false;
    catchAllSwitchLoading = false;
  }

  UsernameDataModel usernameModel;

  bool _activeSwitchLoading;
  bool _catchAllSwitchLoading;

  final createUsernameFormKey = GlobalKey<FormState>();
  final editDescriptionFormKey = GlobalKey<FormState>();
  final _showToast = NicheMethod().showToast;

  get activeSwitchLoading => _activeSwitchLoading;
  get catchAllSwitchLoading => _catchAllSwitchLoading;

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
    if (usernameModel.active) {
      await usernameProvider.deactivateUsername(usernameID).then((value) {
        _showToast('Username Deactivated Successfully!');
        usernameModel.active = false;
      }).catchError((error) {
        _showToast(error.toString());
      });
      activeSwitchLoading = false;
    } else {
      await usernameProvider.activateUsername(usernameID).then((value) {
        usernameModel.active = true;
        _showToast('Username Activated Successfully!');
      }).catchError((error) {
        _showToast(error.toString());
      });
      activeSwitchLoading = false;
    }
  }

  Future<void> toggleCatchAllAlias(
      BuildContext context, String usernameID) async {
    final usernameProvider = context.read(usernameServiceProvider);
    catchAllSwitchLoading = true;
    if (usernameModel.catchAll) {
      await usernameProvider.deactivateCatchAll(usernameID).then((value) {
        _showToast('Catch All Deactivated Successfully!');
        usernameModel.catchAll = false;
      }).catchError((error) {
        _showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    } else {
      await usernameProvider.activateCatchAll(usernameID).then((value) {
        usernameModel.catchAll = true;
        _showToast('Catch All Activated Successfully!');
      }).catchError((error) {
        _showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    }
  }

  Future<void> createNewUsername(BuildContext context, String username) async {
    if (createUsernameFormKey.currentState.validate()) {
      await context
          .read(usernameServiceProvider)
          .createNewUsername(username)
          .then((value) {
        print(value);
        _showToast('Username added successfully!');
        Navigator.pop(context);
      }).catchError((error) {
        _showToast(error.toString());
      });
    }
  }

  Future editDescription(BuildContext context, usernameID, description) async {
    if (editDescriptionFormKey.currentState.validate()) {
      await context
          .read(usernameServiceProvider)
          .editUsernameDescription(usernameID, description)
          .then((value) {
        Navigator.pop(context);
        usernameModel.description = value.description;
        _showToast('Description updated successfully!');
      }).catchError((error) {
        _showToast(error.toString());
      });
    }
  }

  Future updateDefaultRecipient(
      BuildContext context, usernameID, recipientID) async {
    await context
        .read(usernameServiceProvider)
        .updateDefaultRecipient(usernameID, recipientID)
        .then((value) {
      usernameModel.defaultRecipient = value.defaultRecipient;
      notifyListeners();
      _showToast('Default recipient updated successfully!');
      Navigator.pop(context);
    }).catchError((error) {
      _showToast(error.toString());
    });
  }

  Future<void> deleteUsername(BuildContext context, String usernameID) async {
    Navigator.pop(context);
    await context
        .read(usernameServiceProvider)
        .deleteUsername(usernameID)
        .then((value) {
      Navigator.pop(context);
      _showToast('Username deleted successfully!');
    }).catchError((error) {
      _showToast(error.toString());
    });
  }
}
