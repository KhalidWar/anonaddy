import 'dart:async';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/toast_message.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/recipients/data/recipient_screen_service.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipient_screen_state.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientScreenNotifierProvider = AsyncNotifierProvider.family
    .autoDispose<RecipientScreenNotifier, RecipientScreenState, String>(
        RecipientScreenNotifier.new);

class RecipientScreenNotifier
    extends AutoDisposeFamilyAsyncNotifier<RecipientScreenState, String> {
  Future enableEncryption() async {
    try {
      final currentState = state.value!;
      state = AsyncData(currentState.copyWith(isEncryptionToggleLoading: true));
      final newRecipient = await ref
          .read(recipientScreenService)
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
          .read(recipientScreenService)
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
          .read(recipientScreenService)
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
          .read(recipientScreenService)
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
          .read(recipientScreenService)
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
          .read(recipientScreenService)
          .resendVerificationEmail(state.value!.recipient.id);
      Utilities.showToast('Verification email is sent');
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> toggleReplyAndSend() async {
    try {
      final currentState = state.value!;
      final canReplySend = currentState.recipient.canReplySend;

      state =
          AsyncData(currentState.copyWith(isReplySendAndSwitchLoading: true));

      if (canReplySend) {
        await ref
            .read(recipientScreenService)
            .disableReplyAndSend(currentState.recipient.id);

        state = AsyncData(currentState.copyWith(
          recipient: currentState.recipient.copyWith(canReplySend: false),
          isReplySendAndSwitchLoading: false,
        ));
        return;
      }

      final recipient = await ref
          .read(recipientScreenService)
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
          .read(recipientScreenService)
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
          .read(recipientScreenService)
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
          .read(recipientScreenService)
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
          .read(recipientScreenService)
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
    final service = ref.read(recipientScreenService);
    final recipient = await service.fetchRecipient(arg);

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
