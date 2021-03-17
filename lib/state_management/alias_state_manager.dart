import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

final aliasStateManagerProvider =
    ChangeNotifierProvider((ref) => AliasStateManager());

class AliasStateManager extends ChangeNotifier {
  AliasStateManager() {
    _isLoading = false;
  }

  AliasDataModel aliasDataModel;
  bool _isLoading;
  bool _switchValue;
  String _aliasDomain;
  String _aliasFormat;

  final descFieldController = TextEditingController();
  final customFieldController = TextEditingController();
  final customFormKey = GlobalKey<FormState>();
  final descriptionFormKey = GlobalKey<FormState>();

  final freeTierWithSharedDomain = [kUUID, kRandomChars];
  final freeTierNoSharedDomain = [kUUID, kRandomChars, kCustom];
  final paidTierWithSharedDomain = [kUUID, kRandomChars, kRandomWords];
  final paidTierNoSharedDomain = [kUUID, kRandomChars, kRandomWords, kCustom];

  List<AliasDataModel> availableAliasList = [];
  List<AliasDataModel> deletedAliasList = [];
  List<int> forwardedList = [];
  List<int> blockedList = [];
  List<int> repliedList = [];
  List<int> sentList = [];

  bool get isLoading => _isLoading;
  bool get switchValue => _switchValue;
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

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setSwitchValue(bool value) {
    _switchValue = value;
    notifyListeners();
  }

  void toggleSwitchValue() {
    _switchValue = !_switchValue;
    notifyListeners();
  }

  void setEmailDescription(String input) {
    aliasDataModel.emailDescription = input;
    notifyListeners();
  }

  bool isAliasDeleted(dynamic input) {
    if (input == null)
      return false;
    else
      return true;
  }

  void clearAllLists() {
    availableAliasList.clear();
    deletedAliasList.clear();
    forwardedList.clear();
    blockedList.clear();
    repliedList.clear();
    sentList.clear();
  }

  void createNewAlias(BuildContext context, String desc, String domain,
      String format, String localPart) async {
    void createAlias() async {
      setIsLoading(true);
      final aliasService = context.read(aliasServiceProvider);
      await aliasService
          .createNewAlias(desc, domain, format, localPart)
          .then((value) {
        if (value == 201) {
          setIsLoading(false);
          showToast('Alias created successfully!');
        } else {
          setIsLoading(false);
          showToast(value);
        }
        descFieldController.clear();
        customFieldController.clear();
      });
      Navigator.pop(context);
      notifyListeners();
    }

    if (format == 'custom') {
      if (customFormKey.currentState.validate()) {
        createAlias();
      }
    } else {
      createAlias();
    }
  }

  void deleteOrRestoreAlias(
      BuildContext context, DateTime input, String aliasID) async {
    setIsLoading(true);
    final aliasService = context.read(aliasServiceProvider);
    isAliasDeleted(input)
        ? await aliasService.restoreAlias(aliasID).then((response) {
            response == 200
                ? showToast(kAliasRestoredSuccessfully)
                : showToast(kFailedToRestoreAlias);
            setIsLoading(false);
          })
        : await aliasService.deleteAlias(aliasID).then((response) {
            response == 204
                ? showToast(kAliasDeletedSuccessfully)
                : showToast(kFailedToDeleteAlias);
            setIsLoading(false);
          });
    notifyListeners();
  }

  void toggleAlias(BuildContext context, String aliasID) async {
    final aliasService = context.read(aliasServiceProvider);
    setIsLoading(true);
    if (_switchValue) {
      dynamic deactivateResult = await aliasService.deactivateAlias(aliasID);
      if (deactivateResult == null) {
        showToast('Failed to deactivate alias');
        toggleSwitchValue();
        setIsLoading(false);
      } else {
        showToast('Alias deactivated');
        toggleSwitchValue();
        setIsLoading(false);
      }
    } else {
      dynamic activateResult = await aliasService.activateAlias(aliasID);
      if (activateResult == null) {
        showToast('Failed to activate alias');
        toggleSwitchValue();
        setIsLoading(false);
      } else {
        showToast('Alias activated');
        toggleSwitchValue();
        setIsLoading(false);
      }
    }
  }

  void editDescription(
      BuildContext context, String aliasID, String input) async {
    if (descriptionFormKey.currentState.validate()) {
      Navigator.pop(context);
      await context
          .read(aliasServiceProvider)
          .editAliasDescription(aliasID, input)
          .then((value) {
        if (value.emailDescription == null) {
          showToast(kEditDescFailed);
        } else {
          showToast(kEditDescSuccessful);
          setEmailDescription(value.emailDescription);
        }
      });
    }
  }

  void editAliasRecipient(
      BuildContext context, String aliasID, List<String> recipients) async {
    Navigator.pop(context);
    await context
        .read(aliasServiceProvider)
        .editAliasRecipient(aliasID, recipients)
        .then((value) {
      if (value.emailDescription == null) {
        showToast(kEditDescFailed);
      } else {
        showToast(kEditDescSuccessful);
        setEmailDescription(value.emailDescription);
      }
    });
  }

  void copyToClipboard(String input) {
    Clipboard.setData(ClipboardData(text: input));
    showToast(kCopiedToClipboard);
  }

  void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[600],
    );
  }

  String correctAliasString(String input) {
    switch (input) {
      case 'uuid':
        return 'UUID';
      case 'random_characters':
        return 'Random Characters';
      case 'random_words':
        return 'Random Words';
      case 'custom':
        return 'Custom (not available on shared domains)';
    }
  }
}
