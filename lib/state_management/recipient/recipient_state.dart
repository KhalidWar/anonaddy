import 'package:anonaddy/models/recipient/recipient_model.dart';

enum RecipientStatus { loading, loaded, failed }

class RecipientState {
  const RecipientState({
    required this.status,
    this.recipientModel,
    this.errorMessage,
  });

  final RecipientStatus status;
  final RecipientModel? recipientModel;
  final String? errorMessage;
}
