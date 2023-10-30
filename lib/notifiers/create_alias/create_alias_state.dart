import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
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
    required this.account,
  });

  String description;
  String? selectedAliasDomain;
  String? selectedAliasFormat;

  /// Manages list of domains available to be used as [selectedAliasDomain].
  List<String> domains;

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

  bool get showLocalPart =>
      selectedAliasFormat == AnonAddyString.aliasFormatCustom;

  static const sharedDomains = [
    AnonAddyString.sharedDomainsAnonAddyMe,
    AnonAddyString.sharedDomainsAddyMail,
    AnonAddyString.sharedDomains4WRD,
    AnonAddyString.sharedDomainsMailerMe,
  ];
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
    Account? account,
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
      account: account ?? this.account,
    );
  }

  @override
  String toString() {
    return 'CreateAliasState{description: $description, selectedAliasDomain: $selectedAliasDomain, selectedAliasFormat: $selectedAliasFormat, domains: $domains, aliasFormatList: $aliasFormatList, selectedRecipients: $selectedRecipients, localPart: $localPart, isConfirmButtonLoading: $isConfirmButtonLoading, verifiedRecipients: $verifiedRecipients, account: $account}';
  }
}

extension CreateAliasStateExtension on CreateAliasState {
  bool get showLocalPart =>
      selectedAliasFormat == AnonAddyString.aliasFormatCustom;
  bool get isLocalPartValid => localPart.isNotEmpty;
  bool get isDescriptionValid => description.isNotEmpty;
}
