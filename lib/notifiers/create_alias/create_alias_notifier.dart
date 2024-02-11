import 'dart:async';

import 'package:anonaddy/features/account/data/account_service.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/aliases/data/alias_service.dart';
import 'package:anonaddy/features/aliases/presentation/controller/aliases_notifier.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/notifiers/create_alias/create_alias_state.dart';
import 'package:anonaddy/notifiers/settings/settings_notifier.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is the most complex part of this whole project.
///
/// It requires data from several endpoints such as list of verified recipients
/// from [RecipientTabState], domain options for user's default alias domain and format,
/// and subscription status from [AccountTabState]. On top of that, it also some complex
/// conditional logic when creating an alias, several variables have to be
/// accounted for. Feel free to reach out to me if you've any questions.
final createAliasNotifierProvider =
    AsyncNotifierProvider.autoDispose<CreateAliasNotifier, CreateAliasState>(
        CreateAliasNotifier.new);

class CreateAliasNotifier extends AutoDisposeAsyncNotifier<CreateAliasState> {
  Future<void> createNewAlias() async {
    final isAutoCopy = ref.read(settingsNotifier).value!.isAutoCopyEnabled;
    final aliasTabNotifier = ref.read(aliasesNotifierProvider.notifier);

    final currentState = state.value!;

    if (!currentState.isAliasDomainValid) {
      throw Utilities.showToast('Select an alias domain');
    }
    if (!currentState.isAliasFormatValid) {
      throw Utilities.showToast('Select an alias format');
    }

    /// Handles if "Custom" aliasFormat is selected and local part is empty
    if (currentState.showLocalPart && !currentState.isLocalPartValid) {
      throw Utilities.showToast('Provide a valid local part');
    }

    /// Show loading indicator
    state = AsyncData(currentState.copyWith(isConfirmButtonLoading: true));

    try {
      final createdAlias = await ref.read(aliasServiceProvider).createNewAlias(
            domain: currentState.selectedAliasDomain!,
            format: currentState.selectedAliasFormat!,
            desc: currentState.description,
            localPart: currentState.localPart,
            recipients: currentState.selectedRecipients
                .map((recipient) => recipient.id)
                .toList(),
          );

      if (isAutoCopy) {
        await Utilities.copyOnTap(createdAlias.email);
        Utilities.showToast(ToastMessage.createAliasAndCopyEmail);
      } else {
        Utilities.showToast(ToastMessage.createAliasSuccess);
      }

      aliasTabNotifier.addAlias(createdAlias);
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  void setDescription(String? description) {
    state = AsyncData(state.value!.copyWith(description: description));
  }

  void setAliasDomain(String aliasDomain) {
    final currentState = state.value!;

    /// Re-calculate [AliasFormatList] based on currently selected [aliasDomain].
    final aliasFormatList = _getAliasFormatList(
      aliasDomain: aliasDomain,
      isSubscriptionFree: currentState.account.isSubscriptionFree,
      sharedDomains: currentState.sharedDomains,
    );

    /// This is to prevent user from selecting "Custom" (Local Part) when the selected
    /// [AliasDomain] is a shared domain, e.g. "anonaddy.me".
    final isSelectedAliasDomainSharedDomain =
        currentState.sharedDomains.contains(aliasDomain);
    final isSelectedAliasFormatCustom =
        currentState.selectedAliasFormat == AnonAddyString.aliasFormatCustom;
    final shouldUpdatedAliasFormat =
        isSelectedAliasDomainSharedDomain && isSelectedAliasFormatCustom;

    /// Update UI according to the latest AliasFormat and AliasDomain
    final newState = currentState.copyWith(
      aliasFormatList: aliasFormatList,
      selectedAliasDomain: aliasDomain,
      selectedAliasFormat: shouldUpdatedAliasFormat
          ? AnonAddyString.aliasFormatRandomChars
          : currentState.selectedAliasFormat,
    );

    state = AsyncData(newState);
  }

  void setAliasFormat(String aliasFormat) {
    state = AsyncData(state.value!.copyWith(selectedAliasFormat: aliasFormat));
  }

  void setLocalPart(String? localPart) {
    state = AsyncData(state.value!.copyWith(localPart: localPart));
  }

  bool isRecipientSelected(Recipient recipient) {
    return state.value!.selectedRecipients.contains(recipient);
  }

  void toggleRecipient(Recipient recipient) {
    final currentState = state.value!;
    if (currentState.selectedRecipients.contains(recipient)) {
      currentState.selectedRecipients
          .removeWhere((element) => element.email == recipient.email);
    } else {
      currentState.selectedRecipients.add(recipient);
    }

    state = AsyncData(currentState.copyWith());
  }

  /// Sets which list to be used for [AliasFormat] selection.
  ///
  /// For example, if selected [CreateAliasState.selectedAliasDomain] is a shared domain,
  /// [CreateAliasState.aliasFormatList] list can NOT contain [AnonAddyString.aliasFormatCustom].
  /// Another example is that [AnonAddyString.aliasFormatRandomWords] is NOT
  /// available for users with free subscription.
  List<String> _getAliasFormatList({
    required bool isSubscriptionFree,
    required String? aliasDomain,
    required List<String> sharedDomains,
  }) {
    if (sharedDomains.contains(aliasDomain)) {
      return isSubscriptionFree
          ? CreateAliasState.freeTierWithSharedDomain
          : CreateAliasState.paidTierWithSharedDomain;
    }

    return isSubscriptionFree
        ? CreateAliasState.freeTierNoSharedDomain
        : CreateAliasState.paidTierNoSharedDomain;
  }

  @override
  FutureOr<CreateAliasState> build() async {
    final account = await ref.read(accountServiceProvider).fetchAccount();
    final domainOptions =
        await ref.read(domainOptionsService).fetchDomainOptions();
    final recipients = await ref.read(recipientService).fetchRecipients();

    final aliasFormatList = _getAliasFormatList(
      isSubscriptionFree: account.isSubscriptionFree,
      sharedDomains: domainOptions.sharedDomains,
      aliasDomain: domainOptions.defaultAliasDomain,
    );

    /// Sets verified recipients as available recipients that can be selected
    /// Verified recipients have confirmed emails meaning
    /// [Recipient.emailVerifiedAt] has a value, a timestamp of when email was confirmed.
    final verifiedRecipients = recipients
        .where((recipient) => recipient.emailVerifiedAt.isNotEmpty)
        .toList();

    return CreateAliasState(
      domainOptions: domainOptions,
      domains: domainOptions.domains,
      sharedDomains: domainOptions.sharedDomains,
      selectedAliasDomain: domainOptions.defaultAliasDomain,
      selectedAliasFormat: domainOptions.defaultAliasFormat,
      aliasFormatList: aliasFormatList,
      description: '',
      localPart: '',
      verifiedRecipients: verifiedRecipients,
      selectedRecipients: [],
      account: account,
      isConfirmButtonLoading: false,
    );
  }
}
