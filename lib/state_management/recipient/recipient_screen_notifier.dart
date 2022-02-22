import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/state_management/recipient/recipient_screen_state.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_notifier.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientScreenStateNotifier = StateNotifierProvider.autoDispose<
    RecipientScreenNotifier, RecipientScreenState>((ref) {
  return RecipientScreenNotifier(
    recipientService: ref.read(recipientService),
    recipientTabNotifier: ref.read(recipientTabStateNotifier.notifier),
  );
});

class RecipientScreenNotifier extends StateNotifier<RecipientScreenState> {
  RecipientScreenNotifier({
    required this.recipientService,
    required this.recipientTabNotifier,
  }) : super(RecipientScreenState.initialState());

  final RecipientService recipientService;
  final RecipientTabNotifier recipientTabNotifier;

  final showToast = NicheMethod.showToast;

  Future<void> fetchRecipient(Recipient recipient) async {
    /// Initially set RecipientScreen to loading
    state = state.copyWith(status: RecipientScreenStatus.loading);
    try {
      final newRecipient =
          await recipientService.getSpecificRecipient(recipient.id);

      /// Assign newly fetched recipient data to RecipientScreen state
      state = state.copyWith(
          status: RecipientScreenStatus.loaded, recipient: newRecipient);
    } on SocketException {
      /// Return old recipient data if there's no internet connection
      state = state.copyWith(
          status: RecipientScreenStatus.loaded, recipient: recipient);
    } catch (error) {
      state = state.copyWith(
        status: RecipientScreenStatus.failed,
        errorMessage: error.toString(),
      );
    }
  }

  Future enableEncryption(Recipient recipient) async {
    state = state.copyWith(isEncryptionToggleLoading: true);
    try {
      final updatedRecipient =
          await recipientService.enableEncryption(recipient.id);
      recipient.shouldEncrypt = updatedRecipient.shouldEncrypt;
      state = state.copyWith(isEncryptionToggleLoading: false);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(isEncryptionToggleLoading: false);
    }
  }

  Future disableEncryption(Recipient recipient) async {
    state = state.copyWith(isEncryptionToggleLoading: true);
    try {
      await recipientService.disableEncryption(recipient.id);
      recipient.shouldEncrypt = false;
      state = state.copyWith(isEncryptionToggleLoading: false);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(isEncryptionToggleLoading: false);
    }
  }

  Future<void> addPublicGPGKey(Recipient recipient, String keyData) async {
    try {
      final updatedRecipient =
          await recipientService.addPublicGPGKey(recipient.id, keyData);
      recipient.fingerprint = updatedRecipient.fingerprint;
      recipient.shouldEncrypt = updatedRecipient.shouldEncrypt;
      showToast(ToastMessage.addGPGKeySuccess);
      state = state.copyWith(recipient: recipient);
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> removePublicGPGKey(Recipient recipient) async {
    try {
      await recipientService.removePublicGPGKey(recipient.id);
      showToast(ToastMessage.deleteGPGKeySuccess);
      recipient.fingerprint = null;
      recipient.shouldEncrypt = false;
      state = state.copyWith(recipient: recipient);
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> removeRecipient(Recipient recipient) async {
    try {
      await recipientService.removeRecipient(recipient.id);
      showToast('Recipient deleted successfully!');
      recipientTabNotifier.fetchRecipients();
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> verifyEmail(Recipient recipient) async {
    try {
      await recipientService.sendVerificationEmail(recipient.id);
      showToast('Verification email is sent');
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> addRecipient(String email) async {
    state = state.copyWith(isAddRecipientLoading: true);
    try {
      await recipientService.addRecipient(email);
      showToast('Recipient added successfully!');
      state = state.copyWith(isAddRecipientLoading: false);
      recipientTabNotifier.fetchRecipients();
    } catch (error) {
      state = state.copyWith(isAddRecipientLoading: false);
      showToast(error.toString());
    }
  }
}
