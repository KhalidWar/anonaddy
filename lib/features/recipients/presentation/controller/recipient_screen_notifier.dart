import 'dart:async';

import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/recipients/data/recipient_service.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipient_screen_state.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientScreenNotifierProvider = AsyncNotifierProvider.family<
    RecipientScreenNotifier,
    RecipientScreenState,
    String>(RecipientScreenNotifier.new);

class RecipientScreenNotifier
    extends FamilyAsyncNotifier<RecipientScreenState, String> {
  Future<void> fetchSpecificRecipient(Recipient recipient) async {
    try {
      /// Initially set RecipientScreen to loading
      state = const AsyncLoading();
      final newRecipient =
          await ref.read(recipientService).fetchSpecificRecipient(recipient.id);

      /// Assign newly fetched recipient data to RecipientScreen state
      state = AsyncData(state.value!.copyWith(recipient: newRecipient));
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.empty);
    }
  }

  Future enableEncryption() async {
    try {
      final currentState = state.value!;
      state = AsyncData(currentState.copyWith(isEncryptionToggleLoading: true));
      final newRecipient = await ref
          .read(recipientService)
          .enableEncryption(currentState.recipient.id);
      final updateRecipient = currentState.recipient
          .copyWith(shouldEncrypt: newRecipient.shouldEncrypt);
      state = AsyncData(currentState.copyWith(
        recipient: updateRecipient,
        isEncryptionToggleLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(
        state.value!.copyWith(isEncryptionToggleLoading: false),
      );
    }
  }

  Future disableEncryption() async {
    try {
      final currentState = state.value!;
      state = AsyncData(currentState.copyWith(isEncryptionToggleLoading: true));
      await ref
          .read(recipientService)
          .disableEncryption(currentState.recipient.id);

      final updatedRecipient =
          currentState.recipient.copyWith(shouldEncrypt: false);
      state = AsyncData(currentState.copyWith(
        recipient: updatedRecipient,
        isEncryptionToggleLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(
        state.value!.copyWith(isEncryptionToggleLoading: false),
      );
    }
  }

  Future<void> addPublicGPGKey(String keyData) async {
    try {
      final currentState = state.value!;
      final newRecipient = await ref
          .read(recipientService)
          .addPublicGPGKey(currentState.recipient.id, keyData);
      final updatedRecipient = currentState.recipient.copyWith(
          fingerprint: newRecipient.fingerprint,
          shouldEncrypt: newRecipient.shouldEncrypt);
      Utilities.showToast(ToastMessage.addGPGKeySuccess);
      state = AsyncData(currentState.copyWith(recipient: updatedRecipient));
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> removePublicGPGKey() async {
    try {
      final currentState = state.value!;
      await ref
          .read(recipientService)
          .removePublicGPGKey(currentState.recipient.id);
      Utilities.showToast(ToastMessage.deleteGPGKeySuccess);

      final updatedRecipient = currentState.recipient.copyWith(
        fingerprint: '',
        shouldEncrypt: false,
        inlineEncryption: false,
        protectedHeaders: false,
      );
      state = AsyncData(currentState.copyWith(recipient: updatedRecipient));
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> removeRecipient() async {
    try {
      await ref
          .read(recipientService)
          .removeRecipient(state.value!.recipient.id);
      Utilities.showToast('Recipient deleted successfully!');
      _refreshRecipientAndAccountData();
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await ref
          .read(recipientService)
          .resendVerificationEmail(state.value!.recipient.id);
      Utilities.showToast('Verification email is sent');
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> enableReplyAndSend() async {
    try {
      final currentState = state.value!;
      state =
          AsyncData(currentState.copyWith(isReplySendAndSwitchLoading: true));
      final recipient = await ref
          .read(recipientService)
          .enableReplyAndSend(currentState.recipient.id);

      state = AsyncData(currentState.copyWith(
        recipient: recipient,
        isReplySendAndSwitchLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state =
          AsyncData(state.value!.copyWith(isReplySendAndSwitchLoading: false));
    }
  }

  Future disableReplyAndSend() async {
    try {
      final currentState = state.value!;
      state =
          AsyncData(currentState.copyWith(isReplySendAndSwitchLoading: true));
      await ref
          .read(recipientService)
          .disableReplyAndSend(currentState.recipient.id);

      state = AsyncData(currentState.copyWith(
        recipient: currentState.recipient.copyWith(canReplySend: false),
        isReplySendAndSwitchLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state =
          AsyncData(state.value!.copyWith(isReplySendAndSwitchLoading: false));
    }
  }

  Future<void> enableInlineEncryption() async {
    try {
      final currentState = state.value!;
      if (currentState.recipient.protectedHeaders) {
        Utilities.showToast(AppStrings.disableProtectedHeadersFirst);
        return;
      }

      state = AsyncData(
        currentState.copyWith(isInlineEncryptionSwitchLoading: true),
      );
      final recipient = await ref
          .read(recipientService)
          .enableInlineEncryption(currentState.recipient.id);
      state = AsyncData(currentState.copyWith(
        recipient: recipient,
        isInlineEncryptionSwitchLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(
        state.value!.copyWith(isInlineEncryptionSwitchLoading: false),
      );
    }
  }

  Future disableInlineEncryption() async {
    try {
      final currentState = state.value!;
      state = AsyncData(
        currentState.copyWith(isInlineEncryptionSwitchLoading: true),
      );

      await ref
          .read(recipientService)
          .disableInlineEncryption(currentState.recipient.id);
      final updatedRecipient =
          currentState.recipient.copyWith(inlineEncryption: false);
      state = AsyncData(currentState.copyWith(
        recipient: updatedRecipient,
        isInlineEncryptionSwitchLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(
        state.value!.copyWith(isInlineEncryptionSwitchLoading: false),
      );
    }
  }

  Future<void> enableProtectedHeader() async {
    try {
      final currentState = state.value!;
      if (currentState.recipient.inlineEncryption) {
        Utilities.showToast(AppStrings.disableInlineEncryptionFirst);
        return;
      }

      state = AsyncData(
        currentState.copyWith(isProtectedHeaderSwitchLoading: true),
      );
      final recipient = await ref
          .read(recipientService)
          .enableProtectedHeader(currentState.recipient.id);
      state = AsyncData(currentState.copyWith(
        recipient: recipient,
        isProtectedHeaderSwitchLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(
        state.value!.copyWith(isProtectedHeaderSwitchLoading: false),
      );
    }
  }

  Future disableProtectedHeader() async {
    try {
      final currentState = state.value!;
      state = AsyncData(
        currentState.copyWith(isProtectedHeaderSwitchLoading: true),
      );

      await ref
          .read(recipientService)
          .disableProtectedHeader(currentState.recipient.id);

      final updatedRecipient =
          currentState.recipient.copyWith(protectedHeaders: false);
      state = AsyncData(currentState.copyWith(
        recipient: updatedRecipient,
        isProtectedHeaderSwitchLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(
        state.value!.copyWith(isProtectedHeaderSwitchLoading: false),
      );
    }
  }

  void _refreshRecipientAndAccountData() {
    /// Refresh RecipientState after adding/removing a recipient.
    ref.read(recipientsNotifierProvider.notifier).fetchRecipients();

    /// Refresh AccountState data after adding a recipient.
    ref.read(accountNotifierProvider.notifier).fetchAccount();
  }

  @override
  FutureOr<RecipientScreenState> build(String arg) async {
    final service = ref.read(recipientService);
    final recipient = await service.fetchSpecificRecipient(arg);

    return RecipientScreenState(
      recipient: recipient,
      isEncryptionToggleLoading: false,
      isReplySendAndSwitchLoading: false,
      isInlineEncryptionSwitchLoading: false,
      isProtectedHeaderSwitchLoading: false,
      isAddRecipientLoading: false,
    );
  }
}
