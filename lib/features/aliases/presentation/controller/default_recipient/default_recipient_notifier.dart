import 'dart:async';

import 'package:anonaddy/features/aliases/data/alias_service.dart';
import 'package:anonaddy/features/aliases/presentation/controller/alias_screen_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/default_recipient/default_recipient_state.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final defaultRecipientNotifierProvider = AsyncNotifierProvider.family
    .autoDispose<DefaultRecipientNotifier, DefaultRecipientState, String>(
        DefaultRecipientNotifier.new);

class DefaultRecipientNotifier
    extends AutoDisposeFamilyAsyncNotifier<DefaultRecipientState, String> {
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

  Future<void> updateAliasDefaultRecipient() async {
    try {
      final currentState = state.value!;
      state = AsyncData(currentState.copyWith(isCTALoading: true));

      final defaultRecipients =
          currentState.defaultRecipients.map((e) => e.id).toList();
      await ref
          .read(aliasServiceProvider)
          .updateAliasDefaultRecipient(arg, defaultRecipients);

      /// Refreshes [AliasScreen] to reflect latest recipients.
      ref.invalidate(aliasScreenNotifierProvider(arg));

      state = AsyncData(currentState.copyWith(isCTALoading: false));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(isCTALoading: false));
    }
  }

  /// Checks if recipient is [aliasState.aliasId]'s default recipients
  bool isRecipientDefault(Recipient recipient) {
    return state.value!.defaultRecipients
        .map((recipient) => recipient.id)
        .contains(recipient.id);
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
    if (verifiedRecipients.isEmpty || aliasRecipients.isEmpty) {
      return <Recipient>[];
    }

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
  FutureOr<DefaultRecipientState> build(String arg) async {
    final recipients = ref.read(recipientsNotifierProvider).value;
    final alias = ref.read(aliasScreenNotifierProvider(arg)).value?.alias;

    if (recipients == null || alias == null) {
      throw 'Failed to load data';
    }

    final verifiedRecipients = _getVerifiedRecipients(recipients);
    final defaultRecipients = _getDefaultRecipients(
      verifiedRecipients: verifiedRecipients,
      aliasRecipients: alias.recipients,
    );

    return DefaultRecipientState(
      verifiedRecipients: verifiedRecipients,
      defaultRecipients: defaultRecipients,
      isCTALoading: false,
    );
  }
}
