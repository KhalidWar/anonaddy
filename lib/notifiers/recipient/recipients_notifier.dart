import 'dart:async';

import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientsNotifier =
    AsyncNotifierProvider<RecipientsNotifier, List<Recipient>>(
        RecipientsNotifier.new);

class RecipientsNotifier extends AsyncNotifier<List<Recipient>> {
  Future<void> fetchRecipients() async {
    try {
      state = await AsyncValue.guard(
          () => ref.read(recipientService).fetchRecipients());
    } catch (error) {
      rethrow;
    }
  }

  @override
  FutureOr<List<Recipient>> build() async {
    final service = ref.read(recipientService);

    final recipients = await service.loadRecipientsFromDisk();
    if (recipients == null) return await service.fetchRecipients();
    return recipients;
  }
}
