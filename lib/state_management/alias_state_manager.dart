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
  AliasStateManager() {
    isToggleLoading = false;
    deleteAliasLoading = false;
    updateRecipientLoading = false;
  }

  late Alias aliasDataModel;
  late bool isToggleLoading;
  late bool deleteAliasLoading;
  late bool updateRecipientLoading;
  String? _aliasDomain;
  String? _aliasFormat;
  List<Recipient> createAliasRecipients = [];

  final descriptionFormKey = GlobalKey<FormState>();
  final sendFromFormKey = GlobalKey<FormState>();
  final _showToast = NicheMethod().showToast;

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

  Future<void> deleteOrRestoreAlias(
      BuildContext context, bool isAliasDeleted, String aliasID) async {
    final aliasServices = context.read(aliasService);
    setDeleteAliasLoading = true;
    if (!isAliasDeleted) {
      Navigator.pop(context);
      await aliasServices.deleteAlias(aliasID).then((value) {
        _showToast(kDeleteAliasSuccess);
        setDeleteAliasLoading = false;
        Navigator.pop(context);
      }).catchError((error) {
        _showToast(error.toString());
        setDeleteAliasLoading = false;
      });
    } else {
      Navigator.pop(context);
      await aliasServices.restoreAlias(aliasID).then((value) {
        _showToast(kRestoreAliasSuccess);
        setDeleteAliasLoading = false;
        aliasDataModel = value;
      }).catchError((error) {
        _showToast(error.toString());
        setDeleteAliasLoading = false;
      });
    }
    notifyListeners();
  }

  Future<void> toggleAlias(BuildContext context, String aliasID) async {
    final aliasServices = context.read(aliasService);
    setToggleLoading = true;
    if (aliasDataModel.active) {
      await aliasServices.deactivateAlias(aliasID).then((value) {
        _showToast(kDeactivateAliasSuccess);
        aliasDataModel.active = false;
      }).catchError((error) {
        _showToast(error.toString());
      });
      setToggleLoading = false;
    } else {
      await aliasServices.activateAlias(aliasID).then((value) {
        _showToast(kActivateAliasSuccess);
        aliasDataModel.active = true;
      }).catchError((error) {
        _showToast(error.toString());
      });
      setToggleLoading = false;
    }
  }

  Future<void> editDescription(
      BuildContext context, String aliasID, String input) async {
    if (descriptionFormKey.currentState!.validate()) {
      await context
          .read(aliasService)
          .editAliasDescription(aliasID, input)
          .then((value) {
        _showToast(kEditDescriptionSuccess);
        aliasDataModel.description = value.description;
        notifyListeners();
      }).catchError((error) {
        _showToast(error.toString());
      });
      Navigator.pop(context);
    }
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
    if (sendFromFormKey.currentState!.validate()) {
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
  }

  Future<void> updateAliasDefaultRecipient(
      BuildContext context, String aliasID, List<String> recipients) async {
    setUpdateRecipientLoading = true;
    await context
        .read(aliasService)
        .updateAliasDefaultRecipient(aliasID, recipients)
        .then((value) {
      aliasDataModel.recipients = value.recipients;
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
