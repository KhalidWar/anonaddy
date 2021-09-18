import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global_providers.dart';

class AliasStateManager extends ChangeNotifier {
  AliasStateManager({required this.nicheMethod}) {
    isToggleLoading = false;
    deleteAliasLoading = false;
    updateRecipientLoading = false;
    _showToast = nicheMethod.showToast;
  }

  final NicheMethod nicheMethod;

  late bool isToggleLoading;
  late bool deleteAliasLoading;
  late bool updateRecipientLoading;
  late final _showToast;

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

  Future<void> createNewAlias(
      BuildContext context,
      String desc,
      String domain,
      String format,
      String localPart,
      GlobalKey<FormState> customFormKey) async {
    final settings = context.read(settingsStateManagerProvider);
    final recipients = <String>[];
    createAliasRecipients.forEach((element) => recipients.add(element.id));

    Future<void> createAlias() async {
      setToggleLoading = true;
      await context
          .read(aliasService)
          .createNewAlias(desc, domain, format, localPart, recipients)
          .then((value) {
        if (settings.isAutoCopy) {
          Clipboard.setData(ClipboardData(text: value.email));
          _showToast(kCreateAliasAndCopyEmail);
        } else {
          _showToast(kCreateAliasSuccess);
        }
        createAliasRecipients.clear();
      }).catchError((error) {
        _showToast(error.toString());
      });
      setToggleLoading = false;
      Navigator.pop(context);
      _aliasDomain = null;
      _aliasFormat = null;
    }

    if (format == kCustom) {
      if (customFormKey.currentState!.validate()) {
        await createAlias();
      }
    } else {
      await createAlias();
    }
  }

  Future<void> deleteOrRestoreAlias(BuildContext context, Alias alias) async {
    final aliasServices = context.read(aliasService);
    setDeleteAliasLoading = true;
    if (alias.deletedAt == null) {
      Navigator.pop(context);
      await aliasServices.deleteAlias(alias.id).then((value) {
        _showToast(kDeleteAliasSuccess);
        setDeleteAliasLoading = false;
        Navigator.pop(context);
      }).catchError((error) {
        _showToast(error.toString());
        setDeleteAliasLoading = false;
      });
    } else {
      Navigator.pop(context);
      await aliasServices.restoreAlias(alias.id).then((value) {
        _showToast(kRestoreAliasSuccess);
        setDeleteAliasLoading = false;
        alias.deletedAt = value.deletedAt;
      }).catchError((error) {
        _showToast(error.toString());
        setDeleteAliasLoading = false;
      });
    }
    notifyListeners();
  }

  Future<void> toggleAlias(BuildContext context, Alias alias) async {
    final aliasServices = context.read(aliasService);
    setToggleLoading = true;
    if (alias.active) {
      await aliasServices.deactivateAlias(alias.id).then((value) {
        _showToast(kDeactivateAliasSuccess);
        alias.active = false;
      }).catchError((error) {
        _showToast(error.toString());
      });
      setToggleLoading = false;
    } else {
      await aliasServices.activateAlias(alias.id).then((value) {
        _showToast(kActivateAliasSuccess);
        alias.active = true;
      }).catchError((error) {
        _showToast(error.toString());
      });
      setToggleLoading = false;
    }
  }

  Future<void> editDescription(
      BuildContext context, Alias alias, String input) async {
    await context
        .read(aliasService)
        .editAliasDescription(alias.id, input)
        .then((value) {
      _showToast(kEditDescriptionSuccess);
      alias.description = value.description;
      notifyListeners();
    }).catchError((error) {
      _showToast(error.toString());
    });
    Navigator.pop(context);
  }

  Future<void> clearDescription(BuildContext context, Alias alias) async {
    await context
        .read(aliasService)
        .editAliasDescription(alias.id, '')
        .then((value) {
      _showToast(kClearDescriptionSuccess);
      alias.description = value.description;
      notifyListeners();
    }).catchError((error) {
      _showToast(error.toString());
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
      _showToast(kSendFromAliasSuccess);
      Navigator.pop(context);
    }).catchError((error) {
      _showToast(kSomethingWentWrong);
    });
  }

  Future<void> updateAliasDefaultRecipient(
      BuildContext context, Alias alias, List<String> recipients) async {
    setUpdateRecipientLoading = true;
    await context
        .read(aliasService)
        .updateAliasDefaultRecipient(alias.id, recipients)
        .then((value) {
      alias.recipients = value.recipients;
      notifyListeners();
      _showToast(kUpdateAliasRecipientSuccess);
      setUpdateRecipientLoading = false;
      Navigator.pop(context);
    }).catchError((error) {
      _showToast(error.toString());
      setUpdateRecipientLoading = false;
    });
  }

  Future<void> forgetAlias(BuildContext context, String aliasID) async {
    await context.read(aliasService).forgetAlias(aliasID).then((value) {
      _showToast(kForgetAliasSuccess);
    }).catchError((error) {
      _showToast(error.toString());
    });
    Navigator.pop(context);
  }
}
