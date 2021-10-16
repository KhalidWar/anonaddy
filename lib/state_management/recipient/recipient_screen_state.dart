import 'package:anonaddy/models/recipient/recipient_model.dart';

enum RecipientScreenStatus { loading, loaded, failed }

class RecipientScreenState {
  const RecipientScreenState({
    required this.status,
    this.recipient,
    this.errorMessage,
    this.isEncryptionToggleLoading,
    this.isAddRecipientLoading,
  });

  final RecipientScreenStatus status;
  final Recipient? recipient;
  final String? errorMessage;

  final bool? isEncryptionToggleLoading;
  final bool? isAddRecipientLoading;

  RecipientScreenState copyWith({
    RecipientScreenStatus? status,
    Recipient? recipient,
    String? errorMessage,
    bool? isEncryptionToggleLoading,
    bool? isAddRecipientLoading,
  }) {
    return RecipientScreenState(
      status: status ?? this.status,
      recipient: recipient ?? this.recipient,
      errorMessage: errorMessage ?? this.errorMessage,
      isEncryptionToggleLoading:
          isEncryptionToggleLoading ?? this.isEncryptionToggleLoading,
      isAddRecipientLoading:
          isAddRecipientLoading ?? this.isAddRecipientLoading,
    );
  }

  @override
  String toString() {
    return 'RecipientScreenState{status: $status, recipient: $recipient, errorMessage: $errorMessage, isEncryptionToggleLoading: $isEncryptionToggleLoading}';
  }
}
