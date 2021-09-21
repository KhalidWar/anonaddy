import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AliasStateManager extends ChangeNotifier {
  AliasStateManager({
    required this.aliasService,
    required this.nicheMethod,
    required this.isAutoCopy,
  }) {
    showToast = nicheMethod.showToast;
    isToggleLoading = false;
    deleteAliasLoading = false;
    updateRecipientLoading = false;
  }

  final AliasService aliasService;
  final NicheMethod nicheMethod;
  final bool isAutoCopy;

  late Function showToast;
  late bool isToggleLoading;
  late bool deleteAliasLoading;
  late bool updateRecipientLoading;

  String? _aliasDomain;
  String? _aliasFormat;
  List<Recipient> createAliasRecipients = [];

  final freeTierWithSharedDomain = [kUUID, kRandomChars];
  final freeTierNoSharedDomain = [kUUID, kRandomChars, kCustom];
  final paidTierWithSharedDomain = [kUUID, kRandomChars, kRandomWords];
  final paidTierNoSharedDomain = [kUUID, kRandomChars, kRandomWords, kCustom];
  final sharedDomains = [kAnonAddyMe, kAddyMail, k4wrd, kMailerMe];

  String? get aliasDomain => _aliasDomain;
  String? get aliasFormat => _aliasFormat;

  set setAliasDomain(String input) {
    _aliasDomain = input;
    notifyListeners();
  }

  set setAliasFormat(String? input) {
    _aliasFormat = input;
    notifyListeners();
  }

  set setToggleLoading(bool input) {
    isToggleLoading = input;
    notifyListeners();
  }

  set setDeleteAliasLoading(bool input) {
    deleteAliasLoading = input;
    notifyListeners();
  }

  set setUpdateRecipientLoading(bool input) {
    updateRecipientLoading = input;
    notifyListeners();
  }

  set setCreateAliasRecipients(List<Recipient> input) {
    createAliasRecipients = input;
    notifyListeners();
  }

  Future<void> createNewAlias( String desc, String domain,
      String format, String localPart) async {
    final recipients = <String>[];
    createAliasRecipients.forEach((element) => recipients.add(element.id));

    setToggleLoading = true;

    try {
      final createdAlias = await aliasService.createNewAlias(
          desc, domain, format, localPart, recipients);

      if (isAutoCopy) {
        await nicheMethod.copyOnTap(createdAlias.email);
        showToast(kCreateAliasAndCopyEmail);
      } else {
        showToast(kCreateAliasSuccess);
      }
      createAliasRecipients.clear();
    } catch (error) {
      showToast(error.toString());
    }

    setToggleLoading = false;
    _aliasDomain = null;
    _aliasFormat = null;
  }

  Future<void> deleteOrRestoreAlias(BuildContext context, Alias alias) async {
    setDeleteAliasLoading = true;
    if (alias.deletedAt == null) {
      Navigator.pop(context);
      await aliasService.deleteAlias(alias.id).then((value) {
        showToast(kDeleteAliasSuccess);
        setDeleteAliasLoading = false;
        Navigator.pop(context);
      }).catchError((error) {
        showToast(error.toString());
        setDeleteAliasLoading = false;
      });
    } else {
      Navigator.pop(context);
      await aliasService.restoreAlias(alias.id).then((value) {
        showToast(kRestoreAliasSuccess);
        setDeleteAliasLoading = false;
        alias.deletedAt = value.deletedAt;
      }).catchError((error) {
        showToast(error.toString());
        setDeleteAliasLoading = false;
      });
    }
    notifyListeners();
  }

  Future<void> toggleAlias(BuildContext context, Alias alias) async {
    setToggleLoading = true;
    if (alias.active) {
      await aliasService.deactivateAlias(alias.id).then((value) {
        showToast(kDeactivateAliasSuccess);
        alias.active = false;
      }).catchError((error) {
        showToast(error.toString());
      });
      setToggleLoading = false;
    } else {
      await aliasService.activateAlias(alias.id).then((value) {
        showToast(kActivateAliasSuccess);
        alias.active = true;
      }).catchError((error) {
        showToast(error.toString());
      });
      setToggleLoading = false;
    }
  }

  Future<void> editDescription(
      BuildContext context, Alias alias, String input) async {
    await aliasService.editAliasDescription(alias.id, input).then((value) {
      showToast(kEditDescriptionSuccess);
      alias.description = value.description;
      notifyListeners();
    }).catchError((error) {
      showToast(error.toString());
    });
    Navigator.pop(context);
  }

  Future<void> clearDescription(BuildContext context, Alias alias) async {
    await aliasService.editAliasDescription(alias.id, '').then((value) {
      showToast(kClearDescriptionSuccess);
      alias.description = value.description;
      notifyListeners();
    }).catchError((error) {
      showToast(error.toString());
    });
    Navigator.pop(context);
  }

  Future<void> sendFromAlias(
      BuildContext context, String aliasEmail, String destinationEmail) async {
    /// https://anonaddy.com/help/sending-email-from-an-alias/
    final leftPartOfAlias = aliasEmail.split('@')[0];
    final rightPartOfAlias = aliasEmail.split('@')[1];
    final recipientEmail = destinationEmail.replaceAll('@', '=');
    final generatedAddress =
        '$leftPartOfAlias+$recipientEmail@$rightPartOfAlias';

    await Clipboard.setData(ClipboardData(text: generatedAddress))
        .then((value) {
      showToast(kSendFromAliasSuccess);
      Navigator.pop(context);
    }).catchError((error) {
      showToast(kSomethingWentWrong);
    });
  }

  Future<void> updateAliasDefaultRecipient(
      BuildContext context, Alias alias, List<String> recipients) async {
    setUpdateRecipientLoading = true;
    await aliasService
        .updateAliasDefaultRecipient(alias.id, recipients)
        .then((value) {
      alias.recipients = value.recipients;
      notifyListeners();
      showToast(kUpdateAliasRecipientSuccess);
      setUpdateRecipientLoading = false;
      Navigator.pop(context);
    }).catchError((error) {
      showToast(error.toString());
      setUpdateRecipientLoading = false;
    });
  }

  Future<void> forgetAlias(BuildContext context, String aliasID) async {
    await aliasService.forgetAlias(aliasID).then((value) {
      showToast(kForgetAliasSuccess);
    }).catchError((error) {
      showToast(error.toString());
    });
    Navigator.pop(context);
  }
}
