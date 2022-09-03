import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/notifiers/account/account_notifier.dart';
import 'package:anonaddy/notifiers/recipient/recipient_screen_state.dart';
import 'package:anonaddy/notifiers/recipient/recipient_tab_notifier.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
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
    try {
      /// Initially set RecipientScreen to loading
      _updateState(state.copyWith(status: RecipientScreenStatus.loading));
      final newRecipient =
          await recipientService.getSpecificRecipient(recipient.id);

      /// Assign newly fetched recipient data to RecipientScreen state
      final newState = state.copyWith(
          status: RecipientScreenStatus.loaded, recipient: newRecipient);
      _updateState(newState);
    } on DioError catch (dioError) {
      final offlineState = state.copyWith(
        status: RecipientScreenStatus.loaded,
        isOffline: true,
        recipient: recipient,
      );
      final errorState = state.copyWith(
        status: RecipientScreenStatus.failed,
        errorMessage: dioError.message,
      );

      _updateState(
        dioError.type == DioErrorType.other ? offlineState : errorState,
      );
    } catch (error) {
      _updateState(state.copyWith(
        status: RecipientScreenStatus.failed,
        errorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }

  Future enableEncryption() async {
    try {
      _updateState(state.copyWith(isEncryptionToggleLoading: true));
      final newRecipient =
          await recipientService.enableEncryption(state.recipient.id);
      final updateRecipient =
          state.recipient.copyWith(shouldEncrypt: newRecipient.shouldEncrypt);
      _updateState(state.copyWith(
        recipient: updateRecipient,
        isEncryptionToggleLoading: false,
      ));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(isEncryptionToggleLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(isEncryptionToggleLoading: false));
    }
  }

  Future disableEncryption() async {
    try {
      _updateState(state.copyWith(isEncryptionToggleLoading: true));
      await recipientService.disableEncryption(state.recipient.id);
      final updatedRecipient = state.recipient.copyWith(shouldEncrypt: false);
      _updateState(state.copyWith(
        recipient: updatedRecipient,
        isEncryptionToggleLoading: false,
      ));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(isEncryptionToggleLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(isEncryptionToggleLoading: false));
    }
  }

  Future<void> addPublicGPGKey(String keyData) async {
    try {
      final newRecipient =
          await recipientService.addPublicGPGKey(state.recipient.id, keyData);
      final updatedRecipient = state.recipient.copyWith(
          fingerprint: newRecipient.fingerprint,
          shouldEncrypt: newRecipient.shouldEncrypt);
      showToast(ToastMessage.addGPGKeySuccess);
      _updateState(state.copyWith(recipient: updatedRecipient));
    } on DioError catch (dioError) {
      showToast(dioError.message);
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
    }
  }

  Future<void> removePublicGPGKey() async {
    try {
      await recipientService.removePublicGPGKey(state.recipient.id);
      showToast(ToastMessage.deleteGPGKeySuccess);
      final updatedRecipient = state.recipient.copyWith(
        fingerprint: '',
        shouldEncrypt: false,
        inlineEncryption: false,
        protectedHeaders: false,
      );
      _updateState(state.copyWith(recipient: updatedRecipient));
    } on DioError catch (dioError) {
      showToast(dioError.message);
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
    }
  }

  Future<void> removeRecipient() async {
    try {
      await recipientService.removeRecipient(state.recipient.id);
      showToast('Recipient deleted successfully!');
      _refreshRecipientAndAccountData();
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await recipientService.resendVerificationEmail(state.recipient.id);
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

  Future<void> enableReplyAndSend() async {
    try {
      _updateState(state.copyWith(isReplySendAndSwitchLoading: true));
      final recipient =
          await recipientService.enableReplyAndSend(state.recipient.id);
      _updateState(state.copyWith(
        recipient: recipient,
        isReplySendAndSwitchLoading: false,
      ));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(isReplySendAndSwitchLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(isReplySendAndSwitchLoading: false));
    }
  }

  Future disableReplyAndSend() async {
    try {
      _updateState(state.copyWith(isReplySendAndSwitchLoading: true));
      await recipientService.disableReplyAndSend(state.recipient.id);
      final updatedRecipient = state.recipient.copyWith(canReplySend: false);
      _updateState(state.copyWith(
        recipient: updatedRecipient,
        isReplySendAndSwitchLoading: false,
      ));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(isReplySendAndSwitchLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(isReplySendAndSwitchLoading: false));
    }
  }

  Future<void> enableInlineEncryption() async {
    try {
      if (state.recipient.protectedHeaders) {
        showToast(AppStrings.disableProtectedHeadersFirst);
        return;
      }

      _updateState(state.copyWith(isInlineEncryptionSwitchLoading: true));
      final recipient =
          await recipientService.enableInlineEncryption(state.recipient.id);
      _updateState(state.copyWith(
        recipient: recipient,
        isInlineEncryptionSwitchLoading: false,
      ));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(isInlineEncryptionSwitchLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(isInlineEncryptionSwitchLoading: false));
    }
  }

  Future disableInlineEncryption() async {
    try {
      _updateState(state.copyWith(isInlineEncryptionSwitchLoading: true));
      await recipientService.disableInlineEncryption(state.recipient.id);
      final updatedRecipient =
          state.recipient.copyWith(inlineEncryption: false);
      _updateState(state.copyWith(
        recipient: updatedRecipient,
        isInlineEncryptionSwitchLoading: false,
      ));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(isInlineEncryptionSwitchLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(isInlineEncryptionSwitchLoading: false));
    }
  }

  Future<void> enableProtectedHeader() async {
    try {
      if (state.recipient.inlineEncryption) {
        showToast(AppStrings.disableInlineEncryptionFirst);
        return;
      }

      _updateState(state.copyWith(isProtectedHeaderSwitchLoading: true));
      final recipient =
          await recipientService.enableProtectedHeader(state.recipient.id);
      _updateState(state.copyWith(
        recipient: recipient,
        isProtectedHeaderSwitchLoading: false,
      ));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(isProtectedHeaderSwitchLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(isProtectedHeaderSwitchLoading: false));
    }
  }

  Future disableProtectedHeader() async {
    try {
      _updateState(state.copyWith(isProtectedHeaderSwitchLoading: true));
      await recipientService.disableProtectedHeader(state.recipient.id);
      final updatedRecipient =
          state.recipient.copyWith(protectedHeaders: false);
      _updateState(state.copyWith(
        recipient: updatedRecipient,
        isProtectedHeaderSwitchLoading: false,
      ));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(isProtectedHeaderSwitchLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(isProtectedHeaderSwitchLoading: false));
    }
  }

  void _refreshRecipientAndAccountData() {
    /// Refresh RecipientState after adding/removing a recipient.
    recipientTabNotifier.refreshRecipients();

    /// Refresh AccountState data after adding a recipient.
    accountNotifier.refreshAccount();
  }
}
