import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/notifiers/alias_state/alias_screen_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/alias_screen_state.dart';
import 'package:anonaddy/notifiers/alias_state/default_recipient/default_recipient_state.dart';
import 'package:anonaddy/notifiers/recipient/recipients_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final defaultRecipientStateNotifier = StateNotifierProvider.autoDispose<
    DefaultRecipientNotifier, DefaultRecipientState>((ref) {
  return DefaultRecipientNotifier(
    recipients: ref.read(recipientsNotifier).value!,
    aliasState: ref.read(aliasScreenNotifierProvider('')).value!,
  );
});

class DefaultRecipientNotifier extends StateNotifier<DefaultRecipientState> {
  DefaultRecipientNotifier({
    required this.recipients,
    required this.aliasState,
  }) : super(DefaultRecipientState.initial()) {
    /// Extracts verified recipients.
    _setVerifiedRecipients();

    /// Highlights recipients currently set as alias's default recipients.
    _setDefaultRecipients();
  }

  final List<Recipient> recipients;
  final AliasScreenState aliasState;

  /// Updates UI to the latest state
  void _updateState(DefaultRecipientState newState) {
    if (mounted) state = newState;
  }

  /// Toggles selected recipients
  void toggleRecipient(Recipient recipient) {
    if (state.defaultRecipients!.contains(recipient)) {
      state.defaultRecipients!
          .removeWhere((element) => element.email == recipient.email);
    } else {
      state.defaultRecipients!.add(recipient);
    }

    _updateState(state.copyWith());
  }

  /// Checks if recipient is [aliasState.aliasId]'s default recipients
  bool isRecipientDefault(Recipient recipient) {
    bool isDefault = false;
    state.defaultRecipients!.forEach((aliasRecipient) {
      if (aliasRecipient.email == recipient.email) {
        isDefault = true;
      }
    });
    return isDefault;
  }

  /// Extracts recipients IDs from [state.defaultRecipients]
  List<String> getRecipientIds() {
    final recipientIds = <String>[];
    state.defaultRecipients!.forEach((recipient) {
      recipientIds.add(recipient.id);
    });
    return recipientIds;
  }

  /// Extracts verified recipients from all recipients.
  void _setVerifiedRecipients() {
    final verifiedRecipients = <Recipient>[];

    /// Set verified recipients
    for (var recipient in recipients) {
      if (recipient.emailVerifiedAt.isNotEmpty) {
        verifiedRecipients.add(recipient);
      }
    }

    final newState = state.copyWith(verifiedRecipients: verifiedRecipients);
    _updateState(newState);
  }

  /// Extracts current [aliasState.aliasId]'s default recipients
  void _setDefaultRecipients() {
    final defaultRecipients = <Recipient>[];
    for (Recipient verifiedRecipient in state.verifiedRecipients!) {
      for (Recipient aliasRecipient in aliasState.alias.recipients) {
        if (verifiedRecipient.id == aliasRecipient.id) {
          defaultRecipients.add(verifiedRecipient);
        }
      }
    }

    final newState = state.copyWith(defaultRecipients: defaultRecipients);
    _updateState(newState);
  }
}
