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
  final service = ref.read(recipientService);
  final methods = ref.read(nicheMethods);
  final recipientTabNotifier = ref.read(recipientTabStateNotifier.notifier);
  return RecipientScreenNotifier(
    recipientService: service,
    nicheMethod: methods,
    recipientTabNotifier: recipientTabNotifier,
  );
});

class RecipientScreenNotifier extends StateNotifier<RecipientScreenState> {
  RecipientScreenNotifier({
    required this.recipientService,
    required this.nicheMethod,
    required this.recipientTabNotifier,
  }) : super(RecipientScreenState(
          status: RecipientScreenStatus.loading,
          errorMessage: '',
          isEncryptionToggleLoading: false,
          isAddRecipientLoading: false,
        )) {
    showToast = nicheMethod.showToast;
  }

  final RecipientService recipientService;
  final NicheMethod nicheMethod;
  final RecipientTabNotifier recipientTabNotifier;

  late final Function showToast;

  Future<void> fetchRecipient(String recipientId) async {
    state = state.copyWith(status: RecipientScreenStatus.loading);
    try {
      final recipient =
          await recipientService.getSpecificRecipient(recipientId);
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
      showToast(kAddGPGKeySuccess);
      state = state.copyWith(recipient: recipient);
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> removePublicGPGKey(Recipient recipient) async {
    try {
      await recipientService.removePublicGPGKey(recipient.id);
      showToast(kDeleteGPGKeySuccess);
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
