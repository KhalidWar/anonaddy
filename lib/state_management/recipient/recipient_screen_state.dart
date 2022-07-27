import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';

enum RecipientScreenStatus { loading, loaded, failed }

class RecipientScreenState {
  const RecipientScreenState({
    required this.status,
    required this.recipient,
    required this.errorMessage,
    required this.isEncryptionToggleLoading,
    required this.isAddRecipientLoading,
    required this.isOffline,
  });

  final RecipientScreenStatus status;
  final Recipient recipient;
  final String errorMessage;

  final bool isEncryptionToggleLoading;
  final bool isAddRecipientLoading;
  final bool isOffline;

  static RecipientScreenState initialState() {
    return RecipientScreenState(
      status: RecipientScreenStatus.loading,
      recipient: Recipient(),
      errorMessage: AppStrings.somethingWentWrong,
      isEncryptionToggleLoading: false,
      isAddRecipientLoading: false,
      isOffline: false,
    );
  }

  RecipientScreenState copyWith({
    RecipientScreenStatus? status,
    Recipient? recipient,
    String? errorMessage,
    bool? isEncryptionToggleLoading,
    bool? isAddRecipientLoading,
    bool? isOffline,
  }) {
    return RecipientScreenState(
      status: status ?? this.status,
      recipient: recipient ?? this.recipient,
      errorMessage: errorMessage ?? this.errorMessage,
      isEncryptionToggleLoading:
          isEncryptionToggleLoading ?? this.isEncryptionToggleLoading,
      isAddRecipientLoading:
          isAddRecipientLoading ?? this.isAddRecipientLoading,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  String toString() {
    return 'RecipientScreenState{status: $status, recipient: $recipient, errorMessage: $errorMessage, isEncryptionToggleLoading: $isEncryptionToggleLoading, isAddRecipientLoading: $isAddRecipientLoading, isOffline: $isOffline}';
  }
}
