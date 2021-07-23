import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasStateManager extends ChangeNotifier {
  AliasStateManager() {
    isToggleLoading = false;
    deleteAliasLoading = false;
    updateRecipientLoading = false;
  }

  late AliasDataModel aliasDataModel;
  late bool isToggleLoading;
  late bool deleteAliasLoading;
  late bool updateRecipientLoading;
  String? _aliasDomain;
  String? _aliasFormat;
  List<RecipientDataModel> createAliasRecipients = [];

  final descriptionFormKey = GlobalKey<FormState>();
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

  set setCreateAliasRecipients(List<RecipientDataModel> input) {
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
          .read(aliasServiceProvider)
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
    final aliasService = context.read(aliasServiceProvider);
    setDeleteAliasLoading = true;
    if (!isAliasDeleted) {
      Navigator.pop(context);
      await aliasService.deleteAlias(aliasID).then((value) {
        _showToast(kDeleteAliasSuccess);
        setDeleteAliasLoading = false;
        Navigator.pop(context);
      }).catchError((error) {
        _showToast(error.toString());
        setDeleteAliasLoading = false;
      });
    } else {
      Navigator.pop(context);
      await aliasService.restoreAlias(aliasID).then((value) {
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
    final aliasService = context.read(aliasServiceProvider);
    setToggleLoading = true;
    if (aliasDataModel.isAliasActive) {
      await aliasService.deactivateAlias(aliasID).then((value) {
        _showToast(kDeactivateAliasSuccess);
        aliasDataModel.isAliasActive = false;
      }).catchError((error) {
        _showToast(error.toString());
      });
      setToggleLoading = false;
    } else {
      await aliasService.activateAlias(aliasID).then((value) {
        _showToast(kActivateAliasSuccess);
        aliasDataModel.isAliasActive = true;
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
          .read(aliasServiceProvider)
          .editAliasDescription(aliasID, input)
          .then((value) {
        _showToast(kEditDescriptionSuccess);
        aliasDataModel.emailDescription = value.emailDescription;
        notifyListeners();
      }).catchError((error) {
        _showToast(error.toString());
      });
      Navigator.pop(context);
    }
  }

  Future<void> updateAliasDefaultRecipient(
      BuildContext context, String aliasID, List<String> recipients) async {
    setUpdateRecipientLoading = true;
    await context
        .read(aliasServiceProvider)
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
    await context.read(aliasServiceProvider).forgetAlias(aliasID).then((value) {
      _showToast(kForgetAliasSuccess);
    }).catchError((error) {
      _showToast(error.toString());
    });
    Navigator.pop(context);
  }

  String? correctAliasString(String? input) {
    if (input == null) return null;
    switch (input) {
      case 'random_characters':
        return 'Random Characters';
      case 'random_words':
        return 'Random Words';
      case 'custom':
        return 'Custom';
      default:
        return 'UUID';
    }
  }
}
