import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AliasStateManager extends ChangeNotifier {
  AliasStateManager() {
    isToggleLoading = false;
  }

  AliasDataModel aliasDataModel;
  bool _isToggleLoading;
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

  List<AliasDataModel> allAliasesList = [];
  List<AliasDataModel> recentSearchesList = [];

  bool get isToggleLoading => _isToggleLoading;
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

  void createNewAlias(BuildContext context, String desc, String domain,
      String format, String localPart) {
    void createAlias() async {
      isToggleLoading = true;
      await context
          .read(aliasServiceProvider)
          .createNewAlias(desc, domain, format, localPart)
          .then((value) {
        showToast('Alias created successfully!');
      }).catchError((error) {
        showToast(error.toString());
      });
      descFieldController.clear();
      customFieldController.clear();
      isToggleLoading = false;
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

  Future<void> deleteOrRestoreAlias(
      BuildContext context, DateTime aliasDeletedAt, String aliasID) async {
    final aliasService = context.read(aliasServiceProvider);

    if (aliasDeletedAt == null) {
      await aliasService.deleteAlias(aliasID).then((value) {
        showToast(kAliasDeletedSuccessfully);
      }).catchError((error) {
        showToast(error.toString());
      });
      Navigator.pop(context);
    } else {
      await aliasService.restoreAlias(aliasID).then((value) {
        showToast(kAliasRestoredSuccessfully);
      }).catchError((error) {
        showToast(error.toString());
      });
      Navigator.pop(context);
    }
    notifyListeners();
  }

  Future<void> toggleAlias(BuildContext context, String aliasID) async {
    final aliasService = context.read(aliasServiceProvider);
    isToggleLoading = true;
    if (aliasDataModel.isAliasActive) {
      await aliasService.deactivateAlias(aliasID).then((value) {
        showToast('Alias Deactivated Successfully!');
        aliasDataModel.isAliasActive = false;
      }).catchError((error) {
        showToast(error.toString());
      });
      isToggleLoading = false;
    } else {
      await aliasService.activateAlias(aliasID).then((value) {
        showToast('Alias Activated Successfully!');
        aliasDataModel.isAliasActive = true;
      }).catchError((error) {
        showToast(error.toString());
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
        showToast(kEditDescSuccessful);
        aliasDataModel.emailDescription = value.emailDescription;
        notifyListeners();
      }).catchError((error) {
        showToast(error.toString());
      });
      Navigator.pop(context);
    }
  }

  Future<void> updateAliasDefaultRecipient(
      BuildContext context, String aliasID, List<String> recipients) async {
    await context
        .read(aliasServiceProvider)
        .updateAliasDefaultRecipient(aliasID, recipients)
        .then((value) {
      aliasDataModel.recipients = value.recipients;
      notifyListeners();
      showToast(kUpdateAliasRecipientSuccessful);
    }).catchError((error) {
      showToast(error.toString());
    });
    Navigator.pop(context);
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
      case 'random_characters':
        return 'Random Characters';
      case 'random_words':
        return 'Random Words';
      case 'custom':
        return 'Custom (not available on shared domains)';
      default:
        return 'UUID';
    }
  }
}
