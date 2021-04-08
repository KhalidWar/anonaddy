import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecipientStateManager extends ChangeNotifier {
  RecipientStateManager() {
    isLoading = false;
  }

  RecipientDataModel recipientDataModel;
  bool _isLoading;

  final textEditController = TextEditingController();
  final recipientFormKey = GlobalKey<FormState>();
  final pgpKeyFormKey = GlobalKey<FormState>();

  get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setFingerprint(String input) {
    recipientDataModel.fingerprint = input;
    notifyListeners();
  }

  Future<void> toggleEncryption(
      BuildContext context, String recipientID) async {
    isLoading = true;
    if (recipientDataModel.shouldEncrypt) {
      await context
          .read(recipientServiceProvider)
          .disableEncryption(recipientID)
          .then((value) {
        recipientDataModel.shouldEncrypt = false;
        _showToast(kEncryptionDisabled);
      }).catchError((error) {
        _showToast(error.toString());
      });
    } else {
      await context
          .read(recipientServiceProvider)
          .enableEncryption(recipientID)
          .then((value) {
        recipientDataModel.shouldEncrypt = value.shouldEncrypt;
        _showToast(kEncryptionEnabled);
      }).catchError((error) {
        _showToast(error.toString());
      });
    }
    isLoading = false;
  }

  Future<void> addPublicGPGKey(
      BuildContext context, String recipientID, String keyData) async {
    if (pgpKeyFormKey.currentState.validate()) {
      await context
          .read(recipientServiceProvider)
          .addPublicGPGKey(recipientID, keyData)
          .then((value) {
        _showToast(kGPGKeyAddedSuccessfully);
        setFingerprint(value.fingerprint);
        recipientDataModel.shouldEncrypt = value.shouldEncrypt;
        Navigator.pop(context);
      }).catchError((error) {
        _showToast(error.toString());
      });
    }
  }

  Future<void> removePublicGPGKey(
      BuildContext context, String recipientID) async {
    await context
        .read(recipientServiceProvider)
        .removePublicGPGKey(recipientID)
        .then((value) {
      _showToast(kGPGKeyDeletedSuccessfully);
      setFingerprint(null);
      recipientDataModel.shouldEncrypt = false;
    }).catchError((error) {
      _showToast(error.toString());
    });
    Navigator.pop(context);
    notifyListeners();
  }

  Future<void> verifyEmail(BuildContext context, String recipientID) async {
    await context
        .read(recipientServiceProvider)
        .sendVerificationEmail(recipientID)
        .then((value) {
      _showToast('Verification email is sent');
    }).catchError((error) {
      _showToast(error.toString());
    });
  }

  Future<void> addRecipient(BuildContext context, String email) async {
    if (recipientFormKey.currentState.validate()) {
      isLoading = true;
      await context
          .read(recipientServiceProvider)
          .addRecipient(email)
          .then((value) {
        _showToast('Recipient added successfully!');
      }).catchError((error) {
        _showToast(error.toString());
      });
      isLoading = false;
      textEditController.clear();
      Navigator.pop(context);
    }
  }

  Future<void> removeRecipient(BuildContext context, String recipientID) async {
    await context
        .read(recipientServiceProvider)
        .removeRecipient(recipientID)
        .then((value) {
      _showToast('Recipient deleted successfully!');
    }).catchError((error) {
      _showToast(error.toString());
    });
    Navigator.pop(context);
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
