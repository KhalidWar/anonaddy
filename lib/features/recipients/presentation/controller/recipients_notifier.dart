import 'dart:async';

import 'package:anonaddy/features/recipients/data/recipient_service.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientsNotifierProvider =
    AsyncNotifierProvider<RecipientsNotifier, List<Recipient>>(
        RecipientsNotifier.new);

class RecipientsNotifier extends AsyncNotifier<List<Recipient>> {
  Future<void> fetchRecipients({bool showLoading = false}) async {
    if (showLoading) state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(recipientService).fetchRecipients());
  }

  List<Recipient> getVerifiedRecipients() {
    return state.value!.where((recipient) => recipient.isVerified).toList();
  }

  @override
  FutureOr<List<Recipient>> build() async {
    final service = ref.read(recipientService);

    final recipients = await service.loadRecipientsFromDisk();
    if (recipients == null) return await service.fetchRecipients();
    return recipients;
  }
}
