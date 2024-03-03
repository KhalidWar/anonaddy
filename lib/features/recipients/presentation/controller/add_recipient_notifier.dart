import 'dart:async';

import 'package:anonaddy/features/recipients/data/recipient_service.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addRecipientNotifierProvider =
    AsyncNotifierProvider.autoDispose<AddRecipientNotifier, void>(
        AddRecipientNotifier.new);

class AddRecipientNotifier extends AutoDisposeAsyncNotifier<void> {
  Future<void> addRecipient(String email) async {
    try {
      state = const AsyncLoading();

      await ref.read(recipientService).addRecipient(email);
      Utilities.showToast('Recipient added successfully!');
      state = const AsyncData(null);

      await ref
          .read(recipientsNotifierProvider.notifier)
          .fetchRecipients(showLoading: true);
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  @override
  FutureOr<void> build() {
    return null;
  }
}
