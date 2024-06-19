import 'dart:async';

import 'package:anonaddy/features/recipients/data/recipient_service.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientsNotifierProvider =
    AsyncNotifierProvider.autoDispose<RecipientsNotifier, List<Recipient>>(
        RecipientsNotifier.new);

class RecipientsNotifier extends AutoDisposeAsyncNotifier<List<Recipient>> {
  Future<void> fetchRecipients({bool showLoading = false}) async {
    if (showLoading) state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(recipientService).fetchRecipients());
  }

  @override
  FutureOr<List<Recipient>> build() async {
    final service = ref.read(recipientService);

    final recipients = await service.loadCachedData();
    if (recipients != null) return recipients;

    return await service.fetchRecipients();
  }
}
