import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';

enum RecipientScreenStatus { loading, loaded, failed }

class RecipientScreenState {
  const RecipientScreenState({
    required this.status,
    required this.recipient,
    required this.errorMessage,
    required this.isEncryptionToggleLoading,
    required this.isReplySendAndSwitchLoading,
    required this.isInlineEncryptionSwitchLoading,
    required this.isProtectedHeaderSwitchLoading,
    required this.isAddRecipientLoading,
    required this.isOffline,
  });

  final RecipientScreenStatus status;
  final Recipient recipient;
  final String errorMessage;

  final bool isEncryptionToggleLoading;
  final bool isReplySendAndSwitchLoading;
  final bool isInlineEncryptionSwitchLoading;
  final bool isProtectedHeaderSwitchLoading;
  final bool isAddRecipientLoading;
  final bool isOffline;

  static RecipientScreenState initialState() {
    return RecipientScreenState(
      status: RecipientScreenStatus.loading,
      recipient: Recipient(),
      errorMessage: AppStrings.somethingWentWrong,
      isEncryptionToggleLoading: false,
      isReplySendAndSwitchLoading: false,
      isInlineEncryptionSwitchLoading: false,
      isProtectedHeaderSwitchLoading: false,
      isAddRecipientLoading: false,
      isOffline: false,
    );
  }

  RecipientScreenState copyWith({
    RecipientScreenStatus? status,
    Recipient? recipient,
    String? errorMessage,
    bool? isEncryptionToggleLoading,
    bool? isReplySendAndSwitchLoading,
    bool? isInlineEncryptionSwitchLoading,
    bool? isProtectedHeaderSwitchLoading,
    bool? isAddRecipientLoading,
    bool? isOffline,
  }) {
    return RecipientScreenState(
      status: status ?? this.status,
      recipient: recipient ?? this.recipient,
      errorMessage: errorMessage ?? this.errorMessage,
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
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  String toString() {
    return 'RecipientScreenState{status: $status, recipient: $recipient, errorMessage: $errorMessage, isEncryptionToggleLoading: $isEncryptionToggleLoading, isReplySendAndSwitchLoading: $isReplySendAndSwitchLoading, isInlineEncryptionSwitchLoading: $isInlineEncryptionSwitchLoading, isProtectedHeaderSwitchLoading: $isProtectedHeaderSwitchLoading, isAddRecipientLoading: $isAddRecipientLoading, isOffline: $isOffline}';
  }
}
