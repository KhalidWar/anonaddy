import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';

class CreateAliasState {
  CreateAliasState({
    required this.description,
    required this.selectedRecipients,
    required this.selectedAliasFormat,
    required this.selectedAliasDomain,
    required this.localPart,
    required this.aliasFormatList,
    required this.isConfirmButtonLoading,
    required this.verifiedRecipients,
    required this.domains,
    required this.sharedDomains,
    required this.account,
    required this.domainOptions,
  });

  String description;
  String? selectedAliasDomain;
  String? selectedAliasFormat;

  /// Manages list of domains available to be used as [selectedAliasDomain].
  List<String> domains;
  List<String> sharedDomains;

  /// Manages which list to be used for [selectedAliasFormat] selection.
  List<String> aliasFormatList;

  /// Manages selected recipients
  List<Recipient> selectedRecipients;

  String localPart;

  bool isConfirmButtonLoading;

  /// Manages available verified recipients for selection
  List<Recipient> verifiedRecipients;

  /// Informational text at the top of [CreateAlias] sheet
  Account account;
  DomainOptions domainOptions;

  static const freeTierWithSharedDomain = [
    AnonAddyString.aliasFormatUUID,
    AnonAddyString.aliasFormatRandomChars,
  ];
  static const freeTierNoSharedDomain = [
    AnonAddyString.aliasFormatUUID,
    AnonAddyString.aliasFormatRandomChars,
    AnonAddyString.aliasFormatCustom,
  ];
  static const paidTierWithSharedDomain = [
    AnonAddyString.aliasFormatUUID,
    AnonAddyString.aliasFormatRandomChars,
    AnonAddyString.aliasFormatRandomWords,
  ];
  static const paidTierNoSharedDomain = [
    AnonAddyString.aliasFormatUUID,
    AnonAddyString.aliasFormatRandomChars,
    AnonAddyString.aliasFormatRandomWords,
    AnonAddyString.aliasFormatCustom,
  ];

  CreateAliasState copyWith({
    String? description,
    String? selectedAliasFormat,
    String? selectedAliasDomain,
    String? localPart,
    List<String>? aliasFormatList,
    bool? isConfirmButtonLoading,
    List<Recipient>? verifiedRecipients,
    List<Recipient>? selectedRecipients,
    List<String>? domains,
    List<String>? sharedDomains,
    Account? account,
    DomainOptions? domainOptions,
  }) {
    return CreateAliasState(
      description: description ?? this.description,
      selectedAliasFormat: selectedAliasFormat ?? this.selectedAliasFormat,
      selectedAliasDomain: selectedAliasDomain ?? this.selectedAliasDomain,
      localPart: localPart ?? this.localPart,
      aliasFormatList: aliasFormatList ?? this.aliasFormatList,
      isConfirmButtonLoading:
          isConfirmButtonLoading ?? this.isConfirmButtonLoading,
      verifiedRecipients: verifiedRecipients ?? this.verifiedRecipients,
      selectedRecipients: selectedRecipients ?? this.selectedRecipients,
      domains: domains ?? this.domains,
      sharedDomains: sharedDomains ?? this.sharedDomains,
      account: account ?? this.account,
      domainOptions: domainOptions ?? this.domainOptions,
    );
  }

  @override
  String toString() {
    return 'CreateAliasState{description: $description, selectedAliasDomain: $selectedAliasDomain, selectedAliasFormat: $selectedAliasFormat, domains: $domains, sharedDomains: $sharedDomains, aliasFormatList: $aliasFormatList, selectedRecipients: $selectedRecipients, localPart: $localPart, isConfirmButtonLoading: $isConfirmButtonLoading, verifiedRecipients: $verifiedRecipients, account: $account, domainOptions: $domainOptions}';
  }
}

extension CreateAliasStateExtension on CreateAliasState {
  bool get isAliasDomainValid => selectedAliasDomain != null;
  bool get isAliasFormatValid => selectedAliasFormat != null;
  bool get showLocalPart =>
      selectedAliasFormat == AnonAddyString.aliasFormatCustom;
  bool get isLocalPartValid => localPart.isNotEmpty;
  bool get isDescriptionValid => description.isNotEmpty;
  bool get isDefaultAliasFormatCustom =>
      domainOptions.defaultAliasFormat == AnonAddyString.aliasFormatCustom;
}
