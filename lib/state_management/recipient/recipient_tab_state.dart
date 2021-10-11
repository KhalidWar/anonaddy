import 'package:anonaddy/models/recipient/recipient_model.dart';

enum RecipientTabStatus { loading, loaded, failed }

class RecipientTabState {
  const RecipientTabState({
    required this.status,
    this.recipientModel,
    this.errorMessage,
  });

  final RecipientTabStatus status;
  final RecipientModel? recipientModel;
  final String? errorMessage;
}
