import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/create_alias/create_alias_state.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_notifier.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_state.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_state.dart';
import 'package:anonaddy/state_management/settings/settings_notifier.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is the most complex part of this whole project.
///
/// It requires data from several endpoints such as list of verified recipients
/// from [RecipientTabState], domain options for user's default alias domain and format,
/// and subscription status from [AccountTabState]. On top of that, it also some complex
/// conditional logic when creating an alias, several variables have to be
/// accounted for. Feel free to reach out to me if you've any questions.
final createAliasStateNotifier =
    StateNotifierProvider.autoDispose<CreateAliasNotifier, CreateAliasState>(
        (ref) {
  return CreateAliasNotifier(
    aliasService: ref.read(aliasService),
    aliasTabNotifier: ref.read(aliasTabStateNotifier.notifier),
    domainOptions: ref.read(domainOptionsStateNotifier),
    accountState: ref.read(accountStateNotifier),
    recipientState: ref.read(recipientTabStateNotifier),
    isAutoCopy: ref.read(settingsStateNotifier).isAutoCopy ?? false,
  );
});

class CreateAliasNotifier extends StateNotifier<CreateAliasState> {
  CreateAliasNotifier({
    required this.aliasService,
    required this.domainOptions,
    required this.accountState,
    required this.recipientState,
    required this.isAutoCopy,
    required this.aliasTabNotifier,
  }) : super(CreateAliasState.initial(accountState.account)) {
    /// Initially, set [aliasDomain] and [aliasFormat] to default values obtained from
    /// the user's account setting through [domainOptions]. Those values are NULL if
    /// user has NOT set default aliasDomain and/or aliasFormat.

    if (domainOptions.domainOptions != null) {
      /// If null, default to "anonaddy.me".
      setAliasDomain(
          domainOptions.domainOptions!.defaultAliasDomain ?? kAnonAddyMe);

      /// If null, default to "random_characters".
      setAliasFormat(
          domainOptions.domainOptions!.defaultAliasFormat ?? kRandomChars);

      ///
      _setDomains(domainOptions.domainOptions!.domains);
    } else {
      /// If [domainOptions] fails to load data, set the following parameters to be used.
      setAliasDomain(kAnonAddyMe);
      setAliasFormat(kRandomChars);
      _setDomains([]);
    }

    _setVerifiedRecipients();
    _setHeaderText();
  }

  final AliasService aliasService;
  final DomainOptionsState domainOptions;
  final AccountState accountState;
  final RecipientTabState recipientState;
  final bool isAutoCopy;
  final AliasTabNotifier aliasTabNotifier;

  /// Updated UI with the latest state
  void _updateState(CreateAliasState newState) {
    /// Make sure state is mounted before updating to avoid lifecycle errors
    if (mounted) state = newState;
  }

  Future createNewAlias() async {
    /// Handles if "Custom" aliasFormat is selected and local part is empty
    if (state.aliasFormat == kCustom && state.localPart!.isEmpty) {
      throw NicheMethod.showToast('Provide a valid local part');
    }

    /// Show loading indicator
    _updateState(state.copyWith(isLoading: true));

    try {
      final createdAlias = await aliasService.createNewAlias(
        desc: state.description ?? '',
        localPart: state.localPart ?? '',
        domain: state.aliasDomain!,
        format: state.aliasFormat!,
        recipients: _selectedRecipientsId(),
      );

      if (isAutoCopy) {
        await NicheMethod.copyOnTap(createdAlias.email);
        NicheMethod.showToast(ToastMessage.createAliasAndCopyEmail);
      } else {
        NicheMethod.showToast(ToastMessage.createAliasSuccess);
      }

      aliasTabNotifier.addAlias(createdAlias);
    } catch (error) {
      NicheMethod.showToast(error.toString());
    }
    _updateState(state.copyWith(isLoading: false));
  }

  void setDescription(String? description) {
    final newState = state.copyWith(description: description);
    _updateState(newState);
  }

  void setAliasDomain(String aliasDomain) {
    /// Update list used for [AliasFormat] according to currently selected [aliasDomain]
    _setAliasFormatList(aliasDomain);

    /// Set [AliasFormat] field to [kUUID] if the current [AliasFormatList] does NOT
    /// contain "Custom".
    final isCustomIncluded = state.aliasFormatList!.contains(kCustom);

    /// Update UI according to the latest AliasFormat and AliasDomain
    final newState = state.copyWith(
      aliasDomain: aliasDomain,
      aliasFormat: isCustomIncluded ? state.aliasFormat : kRandomChars,
    );
    _updateState(newState);
  }

  void setAliasFormat(String aliasFormat) {
    final newState = state.copyWith(aliasFormat: aliasFormat);
    _updateState(newState);
  }

  void setLocalPart(String? localPart) {
    final newState = state.copyWith(localPart: localPart);
    _updateState(newState);
  }

  void setSelectedRecipients() {
    // final newState = state.copyWith(selectedRecipients: recipients);
    _updateState(state.copyWith());
  }

  void clearSelectedRecipients() {
    state.selectedRecipients!.clear();
    _updateState(state.copyWith());
  }

  bool isRecipientSelected(Recipient recipient) {
    if (state.selectedRecipients!.contains(recipient)) {
      return true;
    } else {
      return false;
    }
  }

  void toggleRecipient(Recipient recipient) {
    if (state.selectedRecipients!.contains(recipient)) {
      state.selectedRecipients!
          .removeWhere((element) => element.email == recipient.email);
    } else {
      state.selectedRecipients!.add(recipient);
    }

    _updateState(state.copyWith());
  }

  void _setDomains(List<String> domains) {
    final newState = state.copyWith(domains: domains);
    _updateState(newState);
  }

  /// Sets which list to be used for [AliasFormat] selection. For example, if selected
  /// [AliasDomain] is a shared domain, e.g. from [CreateAliasState.sharedDomains],
  /// [AliasFormat] list can NOT contain "Custom" and user can NOT use "Custom" (Local Part).
  /// Another example is that [kRandomWords] is NOT available for [kFreeSubscription] users.
  void _setAliasFormatList(String aliasDomain) {
    final subscription = accountState.account!.subscription;
    if (CreateAliasState.sharedDomains.contains(aliasDomain)) {
      if (subscription == kFreeSubscription) {
        state.aliasFormatList = CreateAliasState.freeTierWithSharedDomain;
      } else {
        state.aliasFormatList = CreateAliasState.paidTierWithSharedDomain;
      }
    } else {
      if (subscription == kFreeSubscription) {
        state.aliasFormatList = CreateAliasState.freeTierNoSharedDomain;
      } else {
        state.aliasFormatList = CreateAliasState.paidTierNoSharedDomain;
      }
    }
  }

  /// Sets verified recipients as available recipients that can be selected
  void _setVerifiedRecipients() {
    final verifiedRecipients = <Recipient>[];

    /// Get all recipients related to user's account
    final allRecipients = recipientState.recipients ?? [];

    /// Extract verified recipients
    for (Recipient recipient in allRecipients) {
      /// Verified recipients have confirmed emails meaning
      /// [emailVerifiedAt] has a value, a timestamp of when email was confirmed.
      if (recipient.emailVerifiedAt != null) {
        verifiedRecipients.add(recipient);
      }
    }
    final newState = state.copyWith(verifiedRecipients: verifiedRecipients);
    _updateState(newState);
  }

  void _setHeaderText() {
    final username = accountState.account!.username;
    final text =
        'Other aliases e.g. alias@$username.anonaddy.com or .me can also be created automatically when they receive their first email.';
    final newState = state.copyWith(headerText: text);
    _updateState(newState);
  }

  /// Extracts selected recipients' IDs
  List<String> _selectedRecipientsId() {
    final recipients = <String>[];
    state.selectedRecipients!.forEach((element) {
      recipients.add(element.id);
    });
    return recipients;
  }
}
