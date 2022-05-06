import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_screen_state.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_notifier.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientScreenStateNotifier = StateNotifierProvider.autoDispose<
    RecipientScreenNotifier, RecipientScreenState>((ref) {
  return RecipientScreenNotifier(
    recipientService: ref.read(recipientService),
    recipientTabNotifier: ref.read(recipientTabStateNotifier.notifier),
    accountNotifier: ref.read(accountStateNotifier.notifier),
  );
});

class RecipientScreenNotifier extends StateNotifier<RecipientScreenState> {
  RecipientScreenNotifier({
    required this.recipientService,
    required this.recipientTabNotifier,
    required this.accountNotifier,
  }) : super(RecipientScreenState.initialState());

  final RecipientService recipientService;
  final RecipientTabNotifier recipientTabNotifier;
  final AccountNotifier accountNotifier;

  final showToast = NicheMethod.showToast;

  void _updateState(RecipientScreenState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchRecipient(Recipient recipient) async {
    /// Initially set RecipientScreen to loading
    _updateState(state.copyWith(status: RecipientScreenStatus.loading));
    try {
      final newRecipient =
          await recipientService.getSpecificRecipient(recipient.id);

      /// Assign newly fetched recipient data to RecipientScreen state
      final newState = state.copyWith(
          status: RecipientScreenStatus.loaded, recipient: newRecipient);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;

      if (dioError.type == DioErrorType.other) {
        final newState = state.copyWith(
          status: RecipientScreenStatus.loaded,
          isOffline: true,
          recipient: recipient,
        );
        _updateState(newState);
      } else {
        final newState = state.copyWith(
          status: RecipientScreenStatus.failed,
          errorMessage: dioError.message,
        );
        _updateState(newState);
      }
    }
  }

  Future enableEncryption(Recipient recipient) async {
    _updateState(state.copyWith(isEncryptionToggleLoading: true));
    try {
      final updatedRecipient =
          await recipientService.enableEncryption(recipient.id);
      recipient.shouldEncrypt = updatedRecipient.shouldEncrypt;
      _updateState(state.copyWith(isEncryptionToggleLoading: false));
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
      _updateState(state.copyWith(isEncryptionToggleLoading: false));
    }
  }

  Future disableEncryption(Recipient recipient) async {
    _updateState(state.copyWith(isEncryptionToggleLoading: true));
    try {
      await recipientService.disableEncryption(recipient.id);
      recipient.shouldEncrypt = false;
      _updateState(state.copyWith(isEncryptionToggleLoading: false));
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
      _updateState(state.copyWith(isEncryptionToggleLoading: false));
    }
  }

  Future<void> addPublicGPGKey(Recipient recipient, String keyData) async {
    try {
      final updatedRecipient =
          await recipientService.addPublicGPGKey(recipient.id, keyData);
      recipient.fingerprint = updatedRecipient.fingerprint;
      recipient.shouldEncrypt = updatedRecipient.shouldEncrypt;
      showToast(ToastMessage.addGPGKeySuccess);
      _updateState(state.copyWith(recipient: recipient));
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
    }
  }

  Future<void> removePublicGPGKey(Recipient recipient) async {
    try {
      await recipientService.removePublicGPGKey(recipient.id);
      showToast(ToastMessage.deleteGPGKeySuccess);
      recipient.fingerprint = null;
      recipient.shouldEncrypt = false;
      _updateState(state.copyWith(recipient: recipient));
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
    }
  }

  Future<void> removeRecipient(Recipient recipient) async {
    try {
      await recipientService.removeRecipient(recipient.id);
      showToast('Recipient deleted successfully!');
      _refreshRecipientAndAccountData();
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
    }
  }

  Future<void> resendVerificationEmail(Recipient recipient) async {
    try {
      await recipientService.resendVerificationEmail(recipient.id);
      showToast('Verification email is sent');
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
    }
  }

  Future<void> addRecipient(String email) async {
    _updateState(state.copyWith(isAddRecipientLoading: true));
    try {
      await recipientService.addRecipient(email);
      showToast('Recipient added successfully!');
      _updateState(state.copyWith(isAddRecipientLoading: false));
      _refreshRecipientAndAccountData();
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
      _updateState(state.copyWith(isAddRecipientLoading: false));
    }
  }

  void _refreshRecipientAndAccountData() {
    /// Refresh RecipientState after adding/removing a recipient.
    recipientTabNotifier.refreshRecipients();

    /// Refresh AccountState data after adding a recipient.
    accountNotifier.refreshAccount();
  }
}
