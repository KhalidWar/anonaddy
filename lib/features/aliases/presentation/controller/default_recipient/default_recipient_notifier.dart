import 'dart:async';

import 'package:anonaddy/features/aliases/presentation/controller/alias_screen_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/default_recipient/default_recipient_state.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final defaultRecipientStateNotifier =
    AsyncNotifierProvider<DefaultRecipientNotifier, DefaultRecipientState>(
        DefaultRecipientNotifier.new);

class DefaultRecipientNotifier extends AsyncNotifier<DefaultRecipientState> {
  /// Toggles selected recipients
  void toggleRecipient(Recipient recipient) {
    if (state.value!.defaultRecipients.contains(recipient)) {
      state.value!.defaultRecipients
          .removeWhere((element) => element.email == recipient.email);
    } else {
      state.value!.defaultRecipients.add(recipient);
    }

    state = AsyncData(state.value!.copyWith());
  }

  /// Extracts verified recipients from all recipients.
  List<Recipient> _getVerifiedRecipients(List<Recipient> recipients) {
    if (recipients.isEmpty) return <Recipient>[];

    return recipients.where((recipient) => recipient.isVerified).toList();
  }

  /// Extracts current [aliasState.aliasId]'s default recipients
  List<Recipient> _getDefaultRecipients({
    required List<Recipient> verifiedRecipients,
    required List<Recipient> aliasRecipients,
  }) {
    if (verifiedRecipients.isEmpty) return <Recipient>[];

    final defaultRecipients = <Recipient>[];

    verifiedRecipients.map((verifiedRecipient) {
      final selectedAliasRecipients = aliasRecipients.where((aliasRecipient) {
        if (verifiedRecipient.id == aliasRecipient.id) {
          defaultRecipients.add(verifiedRecipient);
          return true;
        }
        return false;
      }).toList();

      return selectedAliasRecipients;
    }).toList();

    return defaultRecipients;
  }

  @override
  FutureOr<DefaultRecipientState> build() async {
    final recipients = ref.read(recipientsNotifierProvider).value;
    final aliasState = ref.read(aliasScreenNotifierProvider('')).value;

    if (recipients == null || aliasState == null) {
      throw const AsyncError('Failed to load data', StackTrace.empty);
    }

    final verifiedRecipients = _getVerifiedRecipients(recipients);
    final defaultRecipients = _getDefaultRecipients(
      verifiedRecipients: verifiedRecipients,
      aliasRecipients: aliasState.alias.recipients,
    );

    return DefaultRecipientState(
      verifiedRecipients: verifiedRecipients,
      defaultRecipients: defaultRecipients,
    );
  }
}
