import 'dart:async';

import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/notifiers/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/notifiers/create_alias/create_alias_state.dart';
import 'package:anonaddy/notifiers/settings/settings_notifier.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
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
  Future createNewAlias() async {
    final isAutoCopy = ref.read(settingsNotifier).value!.isAutoCopyEnabled;
    final aliasTabNotifier = ref.read(aliasTabStateNotifier.notifier);

    final currentState = state.value!;

    /// Handles if "Custom" aliasFormat is selected and local part is empty
    if (currentState.selectedAliasFormat == AnonAddyString.aliasFormatCustom &&
        currentState.localPart.isEmpty) {
      throw Utilities.showToast('Provide a valid local part');
    }

    /// Show loading indicator
    state = AsyncData(currentState.copyWith(isConfirmButtonLoading: true));

    try {
      final createdAlias = await ref.read(aliasServiceProvider).createNewAlias(
            desc: currentState.description,
            localPart: currentState.localPart,
            domain: currentState.selectedAliasDomain!,
            format: currentState.selectedAliasFormat!,
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
    state = AsyncData(currentState.copyWith(isConfirmButtonLoading: false));
  }

  void setDescription(String? description) {
    state = AsyncData(state.value!.copyWith(description: description));
  }

  void setAliasDomain(String aliasDomain) {
    /// Update list used for [AliasFormat] according to currently selected [aliasDomain]
    // _setAliasFormatList(aliasDomain);

    final currentState = state.value!;

    final aliasFormatList = _getAliasFormatList(
      isSubscriptionFree: currentState.account.isSubscriptionFree,
      aliasDomain: aliasDomain,
    );

    /// Set [AliasFormat] field to [kUUID] if the current [AliasFormatList] does NOT
    /// contain "Custom".
    final isCustomIncluded =
        aliasFormatList.contains(AnonAddyString.aliasFormatCustom);

    /// Update UI according to the latest AliasFormat and AliasDomain
    final newState = currentState.copyWith(
      selectedAliasDomain: aliasDomain,
      selectedAliasFormat: isCustomIncluded
          ? currentState.selectedAliasFormat
          : AnonAddyString.aliasFormatRandomChars,
      aliasFormatList: aliasFormatList,
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

  /// Sets which list to be used for [AliasFormat] selection. For example, if selected
  /// [AliasDomain] is a shared domain, e.g. from [CreateAliasState.sharedDomains],
  /// [AliasFormat] list can NOT contain "Custom" and user can NOT use "Custom" (Local Part).
  /// Another example is that [aliasFormatRandomWords] is NOT available for [subscriptionFree] users.
  List<String> _getAliasFormatList({
    required bool isSubscriptionFree,
    required String? aliasDomain,
  }) {
    if (CreateAliasState.sharedDomains.contains(aliasDomain)) {
      return isSubscriptionFree
          ? CreateAliasState.freeTierWithSharedDomain
          : CreateAliasState.paidTierWithSharedDomain;
    }

    return isSubscriptionFree
        ? CreateAliasState.freeTierNoSharedDomain
        : CreateAliasState.paidTierNoSharedDomain;
  }

  /// Sets verified recipients as available recipients that can be selected
  /// Verified recipients have confirmed emails meaning
  /// [Recipient.emailVerifiedAt] has a value, a timestamp of when email was confirmed.
  List<Recipient> _getVerifiedRecipients(List<Recipient> recipients) {
    return recipients
        .where((recipient) => recipient.emailVerifiedAt.isNotEmpty)
        .toList();
  }

  @override
  FutureOr<CreateAliasState> build() async {
    final account = await ref.read(accountServiceProvider).fetchAccount();
    final domainOptions =
        await ref.read(domainOptionsService).fetchDomainOptions();
    final recipientState = await ref.read(recipientService).fetchRecipients();

    /// Initially, set [aliasDomain] and [aliasFormat] to default values obtained from
    /// the user's account setting through [domainOptions]. Those values are NULL if
    /// user has NOT set default aliasDomain and/or aliasFormat.
    // if (domainOptions != null) {
    //   /// If null, default to "anonaddy.me".
    //   setAliasDomain(
    //     domainOptions.defaultAliasDomain ??
    //         AnonAddyString.sharedDomainsAnonAddyMe,
    //   );
    //
    //   /// If null, default to "random_characters".
    //   setAliasFormat(domainOptions.defaultAliasFormat ??
    //       AnonAddyString.aliasFormatRandomChars);
    // } else {
    //   /// If [domainOptions] fails to load data, set the following parameters to be used.
    //   setAliasDomain(AnonAddyString.sharedDomainsAnonAddyMe);
    //   setAliasFormat(AnonAddyString.aliasFormatRandomChars);
    // }

    final aliasFormatList = _getAliasFormatList(
      isSubscriptionFree: account.isSubscriptionFree,
      aliasDomain: domainOptions.defaultAliasDomain,
    );

    return CreateAliasState(
      domains: domainOptions.domains,
      selectedAliasDomain: domainOptions.defaultAliasDomain,
      selectedAliasFormat: domainOptions.defaultAliasFormat,
      description: '',
      aliasFormatList: aliasFormatList,
      verifiedRecipients: _getVerifiedRecipients(recipientState),
      selectedRecipients: [],
      account: account,
      localPart: '',
      isConfirmButtonLoading: false,
    );
  }
}
