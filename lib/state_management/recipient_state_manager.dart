import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipientStateManager extends ChangeNotifier {
  RecipientStateManager({
    required this.recipientService,
    required this.showToast,
  }) {
    _isLoading = false;
  }

  final RecipientService recipientService;
  final Function showToast;

  late bool _isLoading;

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
      await recipientService.disableEncryption(recipient.id).then((value) {
        recipient.shouldEncrypt = false;
        showToast(kEncryptionDisabled);
      }).catchError((error) {
        showToast(error.toString());
      });
    } else {
      await recipientService.enableEncryption(recipient.id).then((value) {
        recipient.shouldEncrypt = value.shouldEncrypt;
        showToast(kEncryptionEnabled);
      }).catchError((error) {
        showToast(error.toString());
      });
    }
    isLoading = false;
  }

  Future<void> addPublicGPGKey(
      BuildContext context, Recipient recipient, String keyData) async {
    await recipientService.addPublicGPGKey(recipient.id, keyData).then((value) {
      showToast(kAddGPGKeySuccess);
      setFingerprint(recipient, value.fingerprint);
      recipient.shouldEncrypt = value.shouldEncrypt;
      Navigator.pop(context);
    }).catchError((error) {
      showToast(error.toString());
    });
  }

  Future<void> removePublicGPGKey(
      BuildContext context, Recipient recipient) async {
    await recipientService.removePublicGPGKey(recipient.id).then((value) {
      showToast(kDeleteGPGKeySuccess);
      setFingerprint(recipient, null);
      recipient.shouldEncrypt = false;
    }).catchError((error) {
      showToast(error.toString());
    });
    Navigator.pop(context);
    notifyListeners();
  }

  Future<void> verifyEmail(BuildContext context, Recipient recipient) async {
    await recipientService.sendVerificationEmail(recipient.id).then((value) {
      showToast('Verification email is sent');
    }).catchError((error) {
      showToast(error.toString());
    });
  }

  Future<void> addRecipient(BuildContext context, String email) async {
    isLoading = true;
    await recipientService.addRecipient(email).then((value) {
      showToast('Recipient added successfully!');
    }).catchError((error) {
      showToast(error.toString());
    });
    isLoading = false;
    Navigator.pop(context);
  }

  Future<void> removeRecipient(
      BuildContext context, Recipient recipient) async {
    await recipientService.removeRecipient(recipient.id).then((value) {
      showToast('Recipient deleted successfully!');
    }).catchError((error) {
      showToast(error.toString());
    });
    Navigator.pop(context);
  }
}
