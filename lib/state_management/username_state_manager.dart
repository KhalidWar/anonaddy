import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsernameStateManager extends ChangeNotifier {
  UsernameStateManager(
      {required this.usernameService, required this.showToast}) {
    activeSwitchLoading = false;
    catchAllSwitchLoading = false;
    updateRecipientLoading = false;
  }

  final UsernameService usernameService;
  final Function showToast;

  late bool _activeSwitchLoading;
  late bool _catchAllSwitchLoading;
  late bool _updateRecipientLoading;

  final createUsernameFormKey = GlobalKey<FormState>();
  final editDescriptionFormKey = GlobalKey<FormState>();

  bool get activeSwitchLoading => _activeSwitchLoading;
  bool get catchAllSwitchLoading => _catchAllSwitchLoading;
  bool get updateRecipientLoading => _updateRecipientLoading;

  set activeSwitchLoading(bool input) {
    _activeSwitchLoading = input;
    notifyListeners();
  }

  set catchAllSwitchLoading(bool input) {
    _catchAllSwitchLoading = input;
    notifyListeners();
  }

  set updateRecipientLoading(bool input) {
    _updateRecipientLoading = input;
    notifyListeners();
  }

  Future<void> toggleActivity(BuildContext context, Username username) async {
    activeSwitchLoading = true;
    if (username.active) {
      await usernameService.deactivateUsername(username.id).then((newUsername) {
        showToast('Username Deactivated Successfully!');
        username.active = false;
      }).catchError((error) {
        showToast(error.toString());
      });
      activeSwitchLoading = false;
    } else {
      await usernameService.activateUsername(username.id).then((newUsername) {
        username.active = newUsername.active;
        showToast('Username Activated Successfully!');
      }).catchError((error) {
        showToast(error.toString());
      });
      activeSwitchLoading = false;
    }
  }

  Future<void> toggleCatchAll(BuildContext context, Username username) async {
    catchAllSwitchLoading = true;
    if (username.catchAll) {
      await usernameService.deactivateCatchAll(username.id).then((newUsername) {
        showToast('Catch All Deactivated Successfully!');
        username.catchAll = false;
      }).catchError((error) {
        showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    } else {
      await usernameService.activateCatchAll(username.id).then((newUsername) {
        username.catchAll = newUsername.catchAll;
        showToast('Catch All Activated Successfully!');
      }).catchError((error) {
        showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    }
  }

  Future<void> createNewUsername(BuildContext context, String username) async {
    if (createUsernameFormKey.currentState!.validate()) {
      await usernameService.createNewUsername(username).then((username) {
        showToast('Username added successfully!');
        Navigator.pop(context);
      }).catchError((error) {
        showToast(error.toString());
      });
    }
  }

  Future editDescription(
      BuildContext context, Username username, description) async {
    if (editDescriptionFormKey.currentState!.validate()) {
      await usernameService
          .editUsernameDescription(username.id, description)
          .then((newUsername) {
        Navigator.pop(context);
        username.description = newUsername.description;
        showToast('Description updated successfully!');
      }).catchError((error) {
        showToast(error.toString());
      });
    }
  }

  Future updateDefaultRecipient(
      BuildContext context, Username username, String recipientID) async {
    updateRecipientLoading = true;
    await usernameService
        .updateDefaultRecipient(username.id, recipientID)
        .then((newUsername) {
      updateRecipientLoading = false;
      username.defaultRecipient = newUsername.defaultRecipient;
      notifyListeners();
      showToast('Default recipient updated successfully!');
      Navigator.pop(context);
    }).catchError((error) {
      showToast(error.toString());
      updateRecipientLoading = false;
    });
  }

  Future<void> deleteUsername(BuildContext context, Username username) async {
    Navigator.pop(context);
    await usernameService.deleteUsername(username.id).then((newUsername) {
      Navigator.pop(context);
      showToast('Username deleted successfully!');
    }).catchError((error) {
      showToast(error.toString());
    });
  }
}
