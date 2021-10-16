import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_notifier.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createAliasNotifier = ChangeNotifierProvider.autoDispose((ref) {
  return CreateAliasNotifier(
    aliasService: ref.read(aliasService),
    domainOptions: ref.read(domainOptionsStateNotifier),
    accountState: ref.read(accountStateNotifier),
    nicheMethod: ref.read(nicheMethods),
    isAutoCopy: ref.read(settingsStateManagerProvider).isAutoCopy,
    aliasTabNotifier: ref.read(aliasTabStateNotifier.notifier),
  );
});

class CreateAliasNotifier extends ChangeNotifier {
  CreateAliasNotifier({
    required this.aliasService,
    required this.domainOptions,
    required this.accountState,
    required this.nicheMethod,
    required this.isAutoCopy,
    required this.aliasTabNotifier,
  }) : super() {
    aliasDomain = domainOptions.domainOptions!.defaultAliasDomain;
    aliasFormat = domainOptions.domainOptions!.defaultAliasFormat;
    isLoading = false;
    isAliasDomainError = isAliasDomainNull();
    isAliasFormatError = isAliasFormatNull();
  }

  final AliasService aliasService;
  final DomainOptionsState domainOptions;
  final AccountState accountState;
  final NicheMethod nicheMethod;
  final bool isAutoCopy;
  final AliasTabNotifier aliasTabNotifier;

  static const sharedDomains = [kAnonAddyMe, kAddyMail, k4wrd, kMailerMe];
  static const freeTierWithSharedDomain = [kUUID, kRandomChars];
  static const freeTierNoSharedDomain = [kUUID, kRandomChars, kCustom];
  static const paidTierWithSharedDomain = [kUUID, kRandomChars, kRandomWords];
  static const paidTierNoSharedDomain = [
    kUUID,
    kRandomChars,
    kRandomWords,
    kCustom
  ];

  String? aliasFormat;
  String? aliasDomain;
  String? description;
  String? localPart;
  List<String>? aliasFormatList;
  bool? isLoading;
  bool? isAliasDomainError;
  bool? isAliasFormatError;

  List<Recipient> createAliasRecipients = [];

  Future<void> createNewAlias() async {
    setLoading(true);
    final recipients = <String>[];
    createAliasRecipients.forEach((element) => recipients.add(element.id));

    try {
      final createdAlias = await aliasService.createNewAlias(description ?? '',
          aliasDomain!, aliasFormat!, localPart ?? '', recipients);

      if (isAutoCopy) {
        await nicheMethod.copyOnTap(createdAlias.email);
        nicheMethod.showToast(kCreateAliasAndCopyEmail);
      } else {
        nicheMethod.showToast(kCreateAliasSuccess);
      }
      aliasTabNotifier.addAlias(createdAlias);
    } catch (error) {
      nicheMethod.showToast(error.toString());
    }
    setLoading(false);
  }

  void setLoading(bool toggle) {
    isLoading = toggle;
    notifyListeners();
  }

  void setAliasDomain(String aliasDomain) {
    this.aliasDomain = aliasDomain;
    setAliasFormatList(aliasDomain);

    if (sharedDomains.contains(aliasDomain)) {
      aliasFormat = aliasFormatList![0];
    } else {
      aliasFormat = domainOptions.domainOptions!.defaultAliasFormat;
    }
    setAliasDomainError(isAliasDomainNull());
    notifyListeners();
  }

  void setAliasFormat(String aliasFormat) {
    this.aliasFormat = aliasFormat;
    notifyListeners();
  }

  void setDescription(String? description) {
    this.description = description;
    notifyListeners();
  }

  void setLocalPart(String? localPart) {
    this.localPart = localPart;
    notifyListeners();
  }

  void setRecipients(List<Recipient> recipients) {
    createAliasRecipients = recipients;
    notifyListeners();
  }

  void setAliasDomainError(bool toggle) {
    isAliasDomainError = toggle;
    notifyListeners();
  }

  bool isAliasDomainNull() {
    return aliasDomain == null &&
        domainOptions.domainOptions!.defaultAliasDomain == null;
  }

  void setAliasFormatError(bool toggle) {
    isAliasFormatError = toggle;
    notifyListeners();
  }

  bool isAliasFormatNull() {
    return aliasFormat == null &&
        domainOptions.domainOptions!.defaultAliasFormat == null;
  }

  void setAliasFormatList(String aliasDomain) {
    final subscription = accountState.accountModel!.account.subscription;
    if (sharedDomains.contains(aliasDomain)) {
      if (subscription == kFreeSubscription) {
        aliasFormatList = freeTierWithSharedDomain;
      } else {
        aliasFormatList = paidTierWithSharedDomain;
      }
    } else {
      if (subscription == kFreeSubscription) {
        aliasFormatList = freeTierNoSharedDomain;
      } else {
        aliasFormatList = paidTierNoSharedDomain;
      }
    }
  }
}
