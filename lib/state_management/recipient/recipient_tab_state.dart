import 'package:anonaddy/models/recipient/recipient.dart';

enum RecipientTabStatus { loading, loaded, failed }

class RecipientTabState {
  const RecipientTabState({
    required this.status,
    this.recipients,
    this.errorMessage,
  });

  final RecipientTabStatus status;
  final List<Recipient>? recipients;
  final String? errorMessage;
}
