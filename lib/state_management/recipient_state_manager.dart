import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global_providers.dart';

class RecipientStateManager extends ChangeNotifier {
  RecipientStateManager() {
    _isLoading = false;
  }

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

  void setFingerprint(Recipient recipient, String? input) {
    recipient.fingerprint = input;
    notifyListeners();
  }

  Future<void> toggleEncryption(
      BuildContext context, Recipient recipient) async {
    isLoading = true;
    if (recipient.shouldEncrypt) {
      await context
          .read(recipientService)
          .disableEncryption(recipient.id)
          .then((value) {
        recipient.shouldEncrypt = false;
        _showToast(kEncryptionDisabled);
      }).catchError((error) {
        _showToast(error.toString());
      });
    } else {
      await context
          .read(recipientService)
          .enableEncryption(recipient.id)
          .then((value) {
        recipient.shouldEncrypt = value.shouldEncrypt;
        _showToast(kEncryptionEnabled);
      }).catchError((error) {
        _showToast(error.toString());
      });
    }
    isLoading = false;
  }

  Future<void> addPublicGPGKey(
      BuildContext context, Recipient recipient, String keyData) async {
    if (pgpKeyFormKey.currentState!.validate()) {
      await context
          .read(recipientService)
          .addPublicGPGKey(recipient.id, keyData)
          .then((value) {
        _showToast(kAddGPGKeySuccess);
        setFingerprint(recipient, value.fingerprint);
        recipient.shouldEncrypt = value.shouldEncrypt;
        Navigator.pop(context);
      }).catchError((error) {
        _showToast(error.toString());
      });
    }
  }

  Future<void> removePublicGPGKey(
      BuildContext context, Recipient recipient) async {
    await context
        .read(recipientService)
        .removePublicGPGKey(recipient.id)
        .then((value) {
      _showToast(kDeleteGPGKeySuccess);
      setFingerprint(recipient, null);
      recipient.shouldEncrypt = false;
    }).catchError((error) {
      _showToast(error.toString());
    });
    Navigator.pop(context);
    notifyListeners();
  }

  Future<void> verifyEmail(BuildContext context, Recipient recipient) async {
    await context
        .read(recipientService)
        .sendVerificationEmail(recipient.id)
        .then((value) {
      _showToast('Verification email is sent');
    }).catchError((error) {
      _showToast(error.toString());
    });
  }

  Future<void> addRecipient(BuildContext context, String email) async {
    if (recipientFormKey.currentState!.validate()) {
      isLoading = true;
      await context.read(recipientService).addRecipient(email).then((value) {
        _showToast('Recipient added successfully!');
      }).catchError((error) {
        _showToast(error.toString());
      });
      isLoading = false;
      textEditController.clear();
      Navigator.pop(context);
    }
  }

  Future<void> removeRecipient(
      BuildContext context, Recipient recipient) async {
    await context
        .read(recipientService)
        .removeRecipient(recipient.id)
        .then((value) {
      _showToast('Recipient deleted successfully!');
    }).catchError((error) {
      _showToast(error.toString());
    });
    Navigator.pop(context);
  }
}
