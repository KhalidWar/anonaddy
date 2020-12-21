import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

final aliasStateManagerProvider =
    ChangeNotifierProvider((ref) => AliasStateManager());

class AliasStateManager extends ChangeNotifier {
  AliasDataModel _aliasDataModel;
  bool _isLoading = false;
  bool _switchValue;
  String _aliasDomain;
  String _aliasFormat;

  AliasDataModel get aliasDataModel => _aliasDataModel;
  bool get isLoading => _isLoading;
  bool get switchValue => _switchValue;
  String get aliasDomain => _aliasDomain;
  String get aliasFormat => _aliasFormat;

  set setAliasDataModel(AliasDataModel aliasDataModel) {
    print('ALIAS DATA FROM PROVIDER ${aliasDataModel.emailDescription}');
    print('ALIAS DATA FROM PROVIDER ${aliasDataModel.isAliasActive}');
    _aliasDataModel = aliasDataModel;
    notifyListeners();
  }

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

  bool isAliasDeleted(dynamic input) {
    if (input == null)
      return false;
    else
      return true;
  }

  void createNewAlias(
      BuildContext context, String desc, String domain, String format) async {
    setIsLoading(true);
    final aliasService = context.read(aliasServiceProvider);
    final response = await aliasService.createNewAlias(
        desc: desc, domain: domain, format: format);
    if (response == 201) {
      setIsLoading(false);
      showToast('Alias created successfully!');
    } else {
      setIsLoading(false);
      showToast('Failed to create alias');
    }
    Navigator.pop(context);
    notifyListeners();
  }

  void deleteOrRestoreAlias(
      BuildContext context, String input, String aliasID) async {
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

    Navigator.pop(context);
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
}
