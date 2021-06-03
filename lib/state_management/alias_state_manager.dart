import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
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

  AliasDataModel aliasDataModel;
  bool _isToggleLoading;
  bool _deleteAliasLoading;
  bool _updateRecipientLoading;
  String _aliasDomain;
  String _aliasFormat;

  final descFieldController = TextEditingController();
  final customFieldController = TextEditingController();
  final customFormKey = GlobalKey<FormState>();
  final descriptionFormKey = GlobalKey<FormState>();
  final _showToast = NicheMethod().showToast;

  final freeTierWithSharedDomain = [kUUID, kRandomChars];
  final freeTierNoSharedDomain = [kUUID, kRandomChars, kCustom];
  final paidTierWithSharedDomain = [kUUID, kRandomChars, kRandomWords];
  final paidTierNoSharedDomain = [kUUID, kRandomChars, kRandomWords, kCustom];
  final sharedDomains = [kAnonAddyMe, kAddyMail, k4wrd, kMailerMe];

  bool get isToggleLoading => _isToggleLoading;
  bool get deleteAliasLoading => _deleteAliasLoading;
  bool get updateRecipientLoading => _updateRecipientLoading;
  String get aliasDomain => _aliasDomain;
  String get aliasFormat => _aliasFormat;

  set setAliasDomain(String input) {
    _aliasDomain = input;
    notifyListeners();
  }

  set setAliasFormat(String input) {
    _aliasFormat = input;
    notifyListeners();
  }

  set isToggleLoading(bool input) {
    _isToggleLoading = input;
    notifyListeners();
  }

  set deleteAliasLoading(bool input) {
    _deleteAliasLoading = input;
    notifyListeners();
  }

  set updateRecipientLoading(bool input) {
    _updateRecipientLoading = input;
    notifyListeners();
  }

  void createNewAlias(BuildContext context, String desc, String domain,
      String format, String localPart) {
    final settings = context.read(settingsStateManagerProvider);
    void createAlias() async {
      isToggleLoading = true;
      await context
          .read(aliasServiceProvider)
          .createNewAlias(desc, domain, format, localPart)
          .then((value) {
        if (settings.isAutoCopy) {
          Clipboard.setData(ClipboardData(text: value.email));
          _showToast('Alias created and email copied!');
        } else {
          _showToast('Alias created successfully!');
        }
      }).catchError((error) {
        _showToast(error.toString());
      });
      descFieldController.clear();
      customFieldController.clear();
      isToggleLoading = false;
      Navigator.pop(context);
      _aliasFormat = null;
      _aliasDomain = null;
    }

    if (format == 'custom') {
      if (customFormKey.currentState.validate()) {
        createAlias();
      }
    } else {
      createAlias();
    }
  }

  Future<void> deleteOrRestoreAlias(
      BuildContext context, DateTime aliasDeletedAt, String aliasID) async {
    final aliasService = context.read(aliasServiceProvider);
    deleteAliasLoading = true;
    if (aliasDeletedAt == null) {
      Navigator.pop(context);
      await aliasService.deleteAlias(aliasID).then((value) {
        _showToast(kAliasDeletedSuccessfully);
        deleteAliasLoading = false;
        Navigator.pop(context);
      }).catchError((error) {
        _showToast(error.toString());
        deleteAliasLoading = false;
      });
    } else {
      Navigator.pop(context);
      await aliasService.restoreAlias(aliasID).then((value) {
        _showToast(kAliasRestoredSuccessfully);
        deleteAliasLoading = false;
        aliasDataModel = value;
      }).catchError((error) {
        _showToast(error.toString());
        deleteAliasLoading = false;
      });
    }
    notifyListeners();
  }

  Future<void> toggleAlias(BuildContext context, String aliasID) async {
    final aliasService = context.read(aliasServiceProvider);
    isToggleLoading = true;
    if (aliasDataModel.isAliasActive) {
      await aliasService.deactivateAlias(aliasID).then((value) {
        _showToast('Alias Deactivated Successfully!');
        aliasDataModel.isAliasActive = false;
      }).catchError((error) {
        _showToast(error.toString());
      });
      isToggleLoading = false;
    } else {
      await aliasService.activateAlias(aliasID).then((value) {
        _showToast('Alias Activated Successfully!');
        aliasDataModel.isAliasActive = true;
      }).catchError((error) {
        _showToast(error.toString());
      });
      isToggleLoading = false;
    }
  }

  Future<void> editDescription(
      BuildContext context, String aliasID, String input) async {
    if (descriptionFormKey.currentState.validate()) {
      await context
          .read(aliasServiceProvider)
          .editAliasDescription(aliasID, input)
          .then((value) {
        _showToast(kEditDescSuccessful);
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
    updateRecipientLoading = true;
    await context
        .read(aliasServiceProvider)
        .updateAliasDefaultRecipient(aliasID, recipients)
        .then((value) {
      aliasDataModel.recipients = value.recipients;
      notifyListeners();
      _showToast(kUpdateAliasRecipientSuccessful);
      updateRecipientLoading = false;
      Navigator.pop(context);
    }).catchError((error) {
      _showToast(error.toString());
      updateRecipientLoading = false;
    });
  }

  Future<void> forgetAlias(BuildContext context, String aliasID) async {
    await context.read(aliasServiceProvider).forgetAlias(aliasID).then((value) {
      _showToast(kForgetAliasUIString);
    }).catchError((error) {
      _showToast(error.toString());
    });
    Navigator.pop(context);
  }

  String correctAliasString(String input) {
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
