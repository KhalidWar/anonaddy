import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';

class CreateAliasState {
  CreateAliasState({
    this.aliasFormat,
    this.aliasDomain,
    this.description,
    this.localPart,
    this.aliasFormatList,
    this.isLoading,
    this.verifiedRecipients,
    this.selectedRecipients,
    this.account,
    this.domains,
    this.headerText,
  });

  String? aliasDomain;
  String? aliasFormat;

  /// Manages list of domains available to be used as [aliasDomain].
  List<String>? domains;

  /// Manages which list to be used for [aliasFormat] selection.
  List<String>? aliasFormatList;

  /// Manages selected recipients
  List<Recipient>? selectedRecipients;

  String? description;
  String? localPart;

  bool? isLoading;

  /// Manages available verified recipients for selection
  List<Recipient>? verifiedRecipients;

  Account? account;

  /// Informational text at the top of [CreateAlias] sheet
  String? headerText;

  static const sharedDomains = [
    AnonAddyString.sharedDomainsAnonAddyMe,
    AnonAddyString.sharedDomainsAddyMail,
    AnonAddyString.sharedDomains4WRD,
    AnonAddyString.sharedDomainsMailerMe
  ];
  static const freeTierWithSharedDomain = [
    AnonAddyString.aliasFormatUUID,
    AnonAddyString.aliasFormatRandomChars
  ];
  static const freeTierNoSharedDomain = [
    AnonAddyString.aliasFormatUUID,
    AnonAddyString.aliasFormatRandomChars,
    AnonAddyString.aliasFormatCustom
  ];
  static const paidTierWithSharedDomain = [
    AnonAddyString.aliasFormatUUID,
    AnonAddyString.aliasFormatRandomChars,
    AnonAddyString.aliasFormatRandomWords
  ];
  static const paidTierNoSharedDomain = [
    AnonAddyString.aliasFormatUUID,
    AnonAddyString.aliasFormatRandomChars,
    AnonAddyString.aliasFormatRandomWords,
    AnonAddyString.aliasFormatCustom
  ];

  /// The base initial state for [CreateAlias].
  static initial(Account? account) {
    return CreateAliasState(
      isLoading: false,
      localPart: '',
      selectedRecipients: [],
      account: account,
      domains: [],
    );
  }

  CreateAliasState copyWith({
    String? aliasFormat,
    String? aliasDomain,
    String? description,
    String? localPart,
    List<String>? aliasFormatList,
    bool? isLoading,
    List<Recipient>? verifiedRecipients,
    List<Recipient>? selectedRecipients,
    Account? account,
    List<String>? domains,
    String? headerText,
  }) {
    return CreateAliasState(
      aliasFormat: aliasFormat ?? this.aliasFormat,
      aliasDomain: aliasDomain ?? this.aliasDomain,
      description: description ?? this.description,
      localPart: localPart ?? this.localPart,
      aliasFormatList: aliasFormatList ?? this.aliasFormatList,
      isLoading: isLoading ?? this.isLoading,
      verifiedRecipients: verifiedRecipients ?? this.verifiedRecipients,
      selectedRecipients: selectedRecipients ?? this.selectedRecipients,
      account: account ?? this.account,
      domains: domains ?? this.domains,
      headerText: headerText ?? this.headerText,
    );
  }

  @override
  String toString() {
    return 'CreateAliasState{aliasFormat: $aliasFormat, aliasDomain: $aliasDomain, description: $description, localPart: $localPart, aliasFormatList: $aliasFormatList, isLoading: $isLoading, verifiedRecipients: $verifiedRecipients, selectedRecipients: $selectedRecipients, account: $account, domains: $domains, headerText: $headerText}';
  }
}
