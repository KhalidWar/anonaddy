import 'dart:async';

import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/aliases/data/aliases_service.dart';
import 'package:anonaddy/features/aliases/presentation/controller/alias_screen_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/default_recipient/default_recipient_state.dart';
import 'package:anonaddy/features/recipients/data/recipient_service.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
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
          .read(aliasesServiceProvider)
          .updateAliasDefaultRecipient(arg, defaultRecipients);

      /// Refreshes [AliasScreen] to reflect latest recipients.
      ref.invalidate(aliasScreenNotifierProvider(arg));

      state = AsyncData(currentState.copyWith(isCTALoading: false));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(isCTALoading: false));
    }
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
    final aliasState = ref.read(aliasScreenNotifierProvider(arg)).requireValue;
    final recipients = await ref.read(recipientService).fetchRecipients();

    final verifiedRecipients = _getVerifiedRecipients(recipients);

    final defaultRecipients = _getDefaultRecipients(
      verifiedRecipients: verifiedRecipients,
      aliasRecipients: aliasState.alias.recipients,
    );

    return DefaultRecipientState(
      verifiedRecipients: verifiedRecipients,
      defaultRecipients: defaultRecipients,
      isCTALoading: false,
    );
  }
}
