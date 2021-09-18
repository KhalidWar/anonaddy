import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global_providers.dart';

class UsernameStateManager extends ChangeNotifier {
  UsernameStateManager() {
    activeSwitchLoading = false;
    catchAllSwitchLoading = false;
    updateRecipientLoading = false;
  }

  late bool _activeSwitchLoading;
  late bool _catchAllSwitchLoading;
  late bool _updateRecipientLoading;

  final createUsernameFormKey = GlobalKey<FormState>();
  final editDescriptionFormKey = GlobalKey<FormState>();
  final _showToast = NicheMethod().showToast;

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
    final usernameProvider = context.read(usernameService);
    activeSwitchLoading = true;
    if (username.active) {
      await usernameProvider
          .deactivateUsername(username.id)
          .then((newUsername) {
        _showToast('Username Deactivated Successfully!');
        username.active = false;
      }).catchError((error) {
        _showToast(error.toString());
      });
      activeSwitchLoading = false;
    } else {
      await usernameProvider.activateUsername(username.id).then((newUsername) {
        username.active = newUsername.active;
        _showToast('Username Activated Successfully!');
      }).catchError((error) {
        _showToast(error.toString());
      });
      activeSwitchLoading = false;
    }
  }

  Future<void> toggleCatchAll(BuildContext context, Username username) async {
    final usernameProvider = context.read(usernameService);
    catchAllSwitchLoading = true;
    if (username.catchAll) {
      await usernameProvider
          .deactivateCatchAll(username.id)
          .then((newUsername) {
        _showToast('Catch All Deactivated Successfully!');
        username.catchAll = false;
      }).catchError((error) {
        _showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    } else {
      await usernameProvider.activateCatchAll(username.id).then((newUsername) {
        username.catchAll = newUsername.catchAll;
        _showToast('Catch All Activated Successfully!');
      }).catchError((error) {
        _showToast(error.toString());
      });
      catchAllSwitchLoading = false;
    }
  }

  Future<void> createNewUsername(BuildContext context, String username) async {
    if (createUsernameFormKey.currentState!.validate()) {
      await context
          .read(usernameService)
          .createNewUsername(username)
          .then((username) {
        _showToast('Username added successfully!');
        Navigator.pop(context);
      }).catchError((error) {
        _showToast(error.toString());
      });
    }
  }

  Future editDescription(
      BuildContext context, Username username, description) async {
    if (editDescriptionFormKey.currentState!.validate()) {
      await context
          .read(usernameService)
          .editUsernameDescription(username.id, description)
          .then((newUsername) {
        Navigator.pop(context);
        username.description = newUsername.description;
        _showToast('Description updated successfully!');
      }).catchError((error) {
        _showToast(error.toString());
      });
    }
  }

  Future updateDefaultRecipient(
      BuildContext context, Username username, String recipientID) async {
    updateRecipientLoading = true;
    await context
        .read(usernameService)
        .updateDefaultRecipient(username.id, recipientID)
        .then((newUsername) {
      updateRecipientLoading = false;
      username.defaultRecipient = newUsername.defaultRecipient;
      notifyListeners();
      _showToast('Default recipient updated successfully!');
      Navigator.pop(context);
    }).catchError((error) {
      _showToast(error.toString());
      updateRecipientLoading = false;
    });
  }

  Future<void> deleteUsername(BuildContext context, Username username) async {
    Navigator.pop(context);
    await context
        .read(usernameService)
        .deleteUsername(username.id)
        .then((newUsername) {
      Navigator.pop(context);
      _showToast('Username deleted successfully!');
    }).catchError((error) {
      _showToast(error.toString());
    });
  }
}
