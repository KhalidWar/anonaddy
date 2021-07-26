import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientStateManager extends ChangeNotifier {
  RecipientStateManager() {
    _isLoading = false;
  }

  late Recipient recipientDataModel;
  late bool _isLoading;

  final _showToast = NicheMethod().showToast;
  final textEditController = TextEditingController();
  final recipientFormKey = GlobalKey<FormState>();
  final pgpKeyFormKey = GlobalKey<FormState>();

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setFingerprint(String? input) {
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
    if (pgpKeyFormKey.currentState!.validate()) {
      await context
          .read(recipientServiceProvider)
          .addPublicGPGKey(recipientID, keyData)
          .then((value) {
        _showToast(kAddGPGKeySuccess);
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
      _showToast(kDeleteGPGKeySuccess);
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
    if (recipientFormKey.currentState!.validate()) {
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
}
