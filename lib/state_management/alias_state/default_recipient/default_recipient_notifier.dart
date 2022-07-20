import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/state_management/alias_state/alias_screen_notifier.dart';
import 'package:anonaddy/state_management/alias_state/alias_screen_state.dart';
import 'package:anonaddy/state_management/alias_state/default_recipient/default_recipient_state.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final defaultRecipientStateNotifier = StateNotifierProvider.autoDispose<
    DefaultRecipientNotifier, DefaultRecipientState>((ref) {
  return DefaultRecipientNotifier(
    recipientState: ref.read(recipientTabStateNotifier),
    aliasState: ref.read(aliasScreenStateNotifier),
  );
});

class DefaultRecipientNotifier extends StateNotifier<DefaultRecipientState> {
  DefaultRecipientNotifier({
    required this.recipientState,
    required this.aliasState,
  }) : super(DefaultRecipientState.initial()) {
    /// Extracts verified recipients.
    _setVerifiedRecipients();

    /// Highlights recipients currently set as alias's default recipients.
    _setDefaultRecipients();
  }

  final RecipientTabState recipientState;
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

  /// Checks if recipient is [aliasState.alias]'s default recipients
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
    final recipients = recipientState.recipients ?? [];
    final verifiedRecipients = <Recipient>[];

    /// Set verified recipients
    recipients.forEach((recipient) {
      if (recipient.emailVerifiedAt != null) {
        verifiedRecipients.add(recipient);
      }
    });

    final newState = state.copyWith(verifiedRecipients: verifiedRecipients);
    _updateState(newState);
  }

  /// Extracts current [aliasState.alias]'s default recipients
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
