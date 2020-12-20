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

  AliasDataModel get aliasDataModel => _aliasDataModel;
  bool get isLoading => _isLoading;
  bool get switchValue => _switchValue;

  set setAliasDataModel(AliasDataModel aliasDataModel) {
    print('ALIAS DATA FROM PROVIDER ${aliasDataModel.emailDescription}');
    print('ALIAS DATA FROM PROVIDER ${aliasDataModel.isAliasActive}');
    _aliasDataModel = aliasDataModel;
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

  void deleteOrRestoreAlias(
      BuildContext context, String input, String aliasID) async {
    setIsLoading(true);
    isAliasDeleted(input)
        ? await context
            .read(aliasServiceProvider)
            .restoreAlias(aliasID)
            .then((response) {
            response == 200
                ? showToast(kAliasRestoredSuccessfully)
                : showToast(kFailedToRestoreAlias);
            setIsLoading(false);
          })
        : await context
            .read(aliasServiceProvider)
            .deleteAlias(aliasID)
            .then((response) {
            response == 204
                ? showToast(kAliasDeletedSuccessfully)
                : showToast(kFailedToDeleteAlias);
            setIsLoading(false);
          });

    Navigator.pop(context);
    notifyListeners();
  }

  void toggleAlias(BuildContext context, String aliasID) async {
    final _apiService = context.read(aliasServiceProvider);
    setIsLoading(true);
    if (_switchValue) {
      dynamic deactivateResult = await _apiService.deactivateAlias(aliasID);
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
      dynamic activateResult = await _apiService.activateAlias(aliasID);
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
