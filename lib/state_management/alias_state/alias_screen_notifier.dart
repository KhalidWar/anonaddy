import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/state_management/alias_state/alias_screen_state.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasScreenStateNotifier =
    StateNotifierProvider.autoDispose<AliasScreenNotifier, AliasScreenState>(
        (ref) {
  return AliasScreenNotifier(
    aliasService: ref.read(aliasService),
    aliasTabNotifier: ref.read(aliasTabStateNotifier.notifier),
  );
});

class AliasScreenNotifier extends StateNotifier<AliasScreenState> {
  AliasScreenNotifier({
    required this.aliasService,
    required this.aliasTabNotifier,
  }) : super(AliasScreenState.initialState());

  final AliasService aliasService;
  final AliasTabNotifier aliasTabNotifier;

  final showToast = NicheMethod.showToast;

  Future<void> fetchAliases(Alias alias) async {
    /// Initially set AliasScreen to loading
    state = state.copyWith(status: AliasScreenStatus.loading);
    try {
      final updatedAlias = await aliasService.getSpecificAlias(alias.id);

      /// Assign newly fetched alias data to AliasScreen state
      state =
          state.copyWith(status: AliasScreenStatus.loaded, alias: updatedAlias);
    } on SocketException {
      /// Return old alias data if there's no internet connection
      state = state.copyWith(
        status: AliasScreenStatus.loaded,
        isOffline: true,
        alias: alias,
      );
    } catch (error) {
      state = state.copyWith(
        status: AliasScreenStatus.failed,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> editDescription(Alias alias, String newDesc) async {
    try {
      final updatedAlias =
          await aliasService.editAliasDescription(alias.id, newDesc);
      showToast(kEditDescriptionSuccess);
      state = state.copyWith(alias: updatedAlias);
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> toggleOffAlias(String aliasId) async {
    state = state.copyWith(isToggleLoading: true);
    try {
      await aliasService.deactivateAlias(aliasId);
      final oldAlias = state.alias!;
      oldAlias.active = false;
      state = state.copyWith(isToggleLoading: false, alias: oldAlias);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(isToggleLoading: false);
    }
  }

  Future<void> toggleOnAlias(String aliasId) async {
    state = state.copyWith(isToggleLoading: true);
    try {
      final newAlias = await aliasService.activateAlias(aliasId);
      final oldAlias = state.alias!;
      oldAlias.active = newAlias.active;
      state = state.copyWith(isToggleLoading: false, alias: oldAlias);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(isToggleLoading: false);
    }
  }

  Future<void> deleteAlias(String aliasId) async {
    state = state.copyWith(deleteAliasLoading: true);
    try {
      await aliasService.deleteAlias(aliasId);
      showToast(kDeleteAliasSuccess);
      final oldAlias = state.alias!;
      oldAlias.deletedAt = null;
      aliasTabNotifier.refreshAliases();
      state = state.copyWith(deleteAliasLoading: false, alias: oldAlias);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(deleteAliasLoading: false);
    }
  }

  Future<void> restoreAlias(String aliasId) async {
    state = state.copyWith(deleteAliasLoading: true);
    try {
      final newAlias = await aliasService.restoreAlias(aliasId);
      showToast(kRestoreAliasSuccess);
      aliasTabNotifier.refreshAliases();
      state = state.copyWith(deleteAliasLoading: false, alias: newAlias);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(deleteAliasLoading: false);
    }
  }

  Future<void> updateAliasDefaultRecipient(
      Alias alias, List<String> recipients) async {
    state = state.copyWith(updateRecipientLoading: true);
    try {
      final updatedAlias =
          await aliasService.updateAliasDefaultRecipient(alias.id, recipients);
      state =
          state.copyWith(updateRecipientLoading: false, alias: updatedAlias);
    } catch (error) {
      showToast(error.toString());
    }
    state = state.copyWith(updateRecipientLoading: false);
  }

  Future<void> forgetAlias(String aliasID) async {
    try {
      await aliasService.forgetAlias(aliasID);
      showToast(kForgetAliasSuccess);
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
      await NicheMethod.copyOnTap(generatedAddress);
      showToast(kSendFromAliasSuccess);
    } catch (error) {
      showToast(kSomethingWentWrong);
    }
  }
}
