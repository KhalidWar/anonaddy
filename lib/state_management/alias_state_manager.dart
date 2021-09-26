import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AliasStateManager extends ChangeNotifier {
  AliasStateManager({
    required this.aliasService,
    required this.nicheMethod,
  }) {
    showToast = nicheMethod.showToast;
    isToggleLoading = false;
    deleteAliasLoading = false;
    updateRecipientLoading = false;
  }

  final AliasService aliasService;
  final NicheMethod nicheMethod;

  late Function showToast;
  late bool isToggleLoading;
  late bool deleteAliasLoading;
  late bool updateRecipientLoading;

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

  Future<void> deleteOrRestoreAlias(Alias alias) async {
    setDeleteAliasLoading = true;

    Future<void> restoreAlias() async {
      try {
        final restoredAlias = await aliasService.restoreAlias(alias.id);
        showToast(kRestoreAliasSuccess);
        setDeleteAliasLoading = false;
        alias.deletedAt = restoredAlias.deletedAt;
      } catch (error) {
        showToast(error.toString());
        setDeleteAliasLoading = false;
      }
    }

    Future<void> deleteAlias() async {
      try {
        await aliasService.deleteAlias(alias.id);
        showToast(kDeleteAliasSuccess);
        setDeleteAliasLoading = false;
      } catch (error) {
        showToast(error.toString());
        setDeleteAliasLoading = false;
      }
    }

    alias.deletedAt == null ? await deleteAlias() : await restoreAlias();
    notifyListeners();
  }

  Future<void> toggleAlias(Alias alias) async {
    setToggleLoading = true;

    Future<void> toggleOffAlias() async {
      try {
        await aliasService.deactivateAlias(alias.id);
        alias.active = false;
      } catch (error) {
        showToast(error.toString());
      }
    }

    Future<void> toggleOnAlias() async {
      try {
        await aliasService.activateAlias(alias.id);
        alias.active = true;
      } catch (error) {
        showToast(error.toString());
      }
    }

    alias.active ? await toggleOffAlias() : await toggleOnAlias();
    setToggleLoading = false;
  }

  Future<void> editDescription(Alias alias, String newDesc) async {
    try {
      final updatedAlias =
          await aliasService.editAliasDescription(alias.id, newDesc);
      showToast(kEditDescriptionSuccess);
      alias.description = updatedAlias.description;
      notifyListeners();
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> clearDescription(Alias alias) async {
    try {
      final updatedAlias =
          await aliasService.editAliasDescription(alias.id, '');
      showToast(kClearDescriptionSuccess);
      alias.description = updatedAlias.description;
      notifyListeners();
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> sendFromAlias(String aliasEmail, String destinationEmail) async {
    /// https://anonaddy.com/help/sending-email-from-an-alias/
    final leftPartOfAlias = aliasEmail.split('@')[0];
    final rightPartOfAlias = aliasEmail.split('@')[1];
    final recipientEmail = destinationEmail.replaceAll('@', '=');
    final generatedAddress =
        '$leftPartOfAlias+$recipientEmail@$rightPartOfAlias';

    try {
      await nicheMethod.copyOnTap(generatedAddress);
      showToast(kSendFromAliasSuccess);
    } catch (error) {
      showToast(kSomethingWentWrong);
    }
  }

  Future<void> updateAliasDefaultRecipient(
      Alias alias, List<String> recipients) async {
    setUpdateRecipientLoading = true;

    try {
      final updatedAlias =
          await aliasService.updateAliasDefaultRecipient(alias.id, recipients);
      alias.recipients = updatedAlias.recipients;
      notifyListeners();
    } catch (error) {
      showToast(error.toString());
    }

    setUpdateRecipientLoading = false;
  }

  Future<void> forgetAlias(String aliasID) async {
    try {
      await aliasService.forgetAlias(aliasID);
      showToast(kForgetAliasSuccess);
    } catch (error) {
      showToast(error.toString());
    }
  }
}
