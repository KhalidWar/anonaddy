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
  RecipientDataModel recipientDataModel;
  bool _encryptionSwitch;
  bool _isLoading = false;

  final textEditController = TextEditingController();
  final recipientFormKey = GlobalKey<FormState>();
  final pgpKeyFormKey = GlobalKey<FormState>();

  get encryptionSwitch => _encryptionSwitch;
  get isLoading => _isLoading;

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

  void setFingerprint(dynamic input) {
    recipientDataModel.fingerprint = input;
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
          _showToast('$kFailedToDisableEncryption: $value');
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
          _showToast('$kFailedToEnableEncryption: $value');
        }
      });
    }
  }

  void addPublicGPGKey(
      BuildContext context, String recipientID, String keyData) async {
    if (pgpKeyFormKey.currentState.validate()) {
      Navigator.pop(context);
      await context
          .read(recipientServiceProvider)
          .addPublicGPGKey(recipientID, keyData)
          .then((value) {
        _showToast(kGPGKeyAddedSuccessfully);
        setFingerprint(value.fingerprint);
        setEncryptionSwitch(value.shouldEncrypt);
      }).catchError((error, stackTrace) {
        _showToast(error);
      });
    }
  }

  void removePublicGPGKey(BuildContext context, String recipientID) async {
    Navigator.pop(context);
    await context
        .read(recipientServiceProvider)
        .removePublicGPGKey(recipientID)
        .then((value) {
      _showToast(kGPGKeyDeletedSuccessfully);
      setEncryptionSwitch(false);
      setFingerprint(null);
    }).catchError((error, stackTrace) {
      _showToast('$kFailedToDeleteGPGKey: $error');
    });
  }

  void verifyEmail(BuildContext context, String recipientID) async {
    await context
        .read(recipientServiceProvider)
        .sendVerificationEmail(recipientID)
        .then((value) {
      if (value == 200) {
        _showToast('Verification email is sent');
      } else {
        _showToast('Failed to send verification email');
      }
    });
  }

  void addRecipient(BuildContext context, String email) async {
    if (recipientFormKey.currentState.validate()) {
      await context
          .read(recipientServiceProvider)
          .addRecipient(email)
          .then((value) {
        _showToast('Recipient added successfully!');
        Navigator.pop(context);
        textEditController.clear();
      }).catchError((error, stackTrace) {
        return _showToast(error);
      });
    }
  }

  void removeRecipient(BuildContext context, String recipientID) async {
    await context
        .read(recipientServiceProvider)
        .removeRecipient(recipientID)
        .then((value) {
      if (value == 204) {
        _showToast('Recipient deleted successfully!');
      } else {
        _showToast('Failed to delete recipient!');
      }
      Navigator.pop(context);
    }).catchError((error, stackTrace) {
      return _showToast(error);
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
