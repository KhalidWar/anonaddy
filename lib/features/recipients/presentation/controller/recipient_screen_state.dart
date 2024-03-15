import 'package:anonaddy/features/recipients/domain/recipient.dart';

class RecipientScreenState {
  const RecipientScreenState({
    required this.recipient,
    required this.isEncryptionToggleLoading,
    required this.isReplySendAndSwitchLoading,
    required this.isInlineEncryptionSwitchLoading,
    required this.isProtectedHeaderSwitchLoading,
    required this.isAddRecipientLoading,
  });

  final Recipient recipient;
  final bool isEncryptionToggleLoading;
  final bool isReplySendAndSwitchLoading;
  final bool isInlineEncryptionSwitchLoading;
  final bool isProtectedHeaderSwitchLoading;
  final bool isAddRecipientLoading;

  RecipientScreenState copyWith({
    Recipient? recipient,
    bool? isEncryptionToggleLoading,
    bool? isReplySendAndSwitchLoading,
    bool? isInlineEncryptionSwitchLoading,
    bool? isProtectedHeaderSwitchLoading,
    bool? isAddRecipientLoading,
    bool? isOffline,
  }) {
    return RecipientScreenState(
      recipient: recipient ?? this.recipient,
      isEncryptionToggleLoading:
          isEncryptionToggleLoading ?? this.isEncryptionToggleLoading,
      isReplySendAndSwitchLoading:
          isReplySendAndSwitchLoading ?? this.isReplySendAndSwitchLoading,
      isInlineEncryptionSwitchLoading: isInlineEncryptionSwitchLoading ??
          this.isInlineEncryptionSwitchLoading,
      isProtectedHeaderSwitchLoading:
          isProtectedHeaderSwitchLoading ?? this.isProtectedHeaderSwitchLoading,
      isAddRecipientLoading:
          isAddRecipientLoading ?? this.isAddRecipientLoading,
    );
  }

  @override
  String toString() {
    return 'RecipientScreenState{recipient: $recipient, isEncryptionToggleLoading: $isEncryptionToggleLoading, isReplySendAndSwitchLoading: $isReplySendAndSwitchLoading, isInlineEncryptionSwitchLoading: $isInlineEncryptionSwitchLoading, isProtectedHeaderSwitchLoading: $isProtectedHeaderSwitchLoading, isAddRecipientLoading: $isAddRecipientLoading}';
  }
}
