import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

final recipientStateManagerProvider =
    ChangeNotifierProvider((ref) => RecipientStateManager());

class RecipientStateManager extends ChangeNotifier {
  RecipientDataModel _recipientDataModel;
  bool _encryptionSwitch;
  bool _isLoading = false;

  get encryptionSwitch => _encryptionSwitch;
  get isLoading => _isLoading;

  void setRecipientData(RecipientDataModel recipient) {
    _recipientDataModel = recipient;
    notifyListeners();
  }

  void setEncryptionSwitch(bool value) {
    _encryptionSwitch = value;
    notifyListeners();
  }

  void _toggleEncryptionSwitch() {
    _encryptionSwitch = !_encryptionSwitch;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setFingerprint() {
    _recipientDataModel.fingerprint = null;
    notifyListeners();
  }

  void toggleEncryption(BuildContext context, String recipientID) async {
    setIsLoading(true);
    if (_encryptionSwitch) {
      await context
          .read(recipientServiceProvider)
          .disableEncryption(recipientID)
          .then((value) {
        if (value == 204) {
          setIsLoading(false);
          _toggleEncryptionSwitch();
          _showToast(kEncryptionDisabled);
        } else {
          setIsLoading(false);
          _showToast(kFailedToDisableEncryption);
        }
      });
    } else {
      await context
          .read(recipientServiceProvider)
          .enableEncryption(recipientID)
          .then((value) {
        if (value == 200) {
          setIsLoading(false);
          _toggleEncryptionSwitch();
          _showToast(kEncryptionEnabled);
        } else {
          setIsLoading(false);
          _showToast(kFailedToEnableEncryption);
        }
      });
    }
  }

  void removePublicGPGKey(BuildContext context, String recipientID) async {
    Navigator.pop(context);
    setIsLoading(true);
    await context
        .read(recipientServiceProvider)
        .removePublicGPGKey(recipientID)
        .then((value) {
      if (value == 204) {
        _showToast(kGPGKeyDeletedSuccessfully);
        setIsLoading(false);
        setEncryptionSwitch(false);
        setFingerprint();
      } else {
        _showToast(kFailedToDeleteGPGKey);
        setIsLoading(false);
      }
    });
  }

  void verifyEmail(BuildContext context, String recipientID) async {
    setIsLoading(true);
    await context
        .read(recipientServiceProvider)
        .sendVerificationEmail(recipientID)
        .then((value) {
      if (value == 200) {
        _showToast('Verification email is sent');
        setIsLoading(false);
      } else {
        _showToast('Failed to send verification email');
        setIsLoading(false);
      }
    });
  }

  void copyOnTap(String input) {
    Clipboard.setData(ClipboardData(text: input));
    _showToast(kCopiedToClipboard);
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
