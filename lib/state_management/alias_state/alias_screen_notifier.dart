import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:anonaddy/state_management/alias_state/alias_screen_state.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:dio/dio.dart';
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

  void _updateState(AliasScreenState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchSpecificAlias(Alias alias) async {
    /// Initially set AliasScreen to loading
    final newState = state.copyWith(status: AliasScreenStatus.loading);
    _updateState(newState);
    try {
      final updatedAlias = await aliasService.getSpecificAlias(alias.id);

      /// Assign newly fetched alias data to AliasScreen state
      final newState =
          state.copyWith(status: AliasScreenStatus.loaded, alias: updatedAlias);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      if (dioError.type == DioErrorType.other) {
        final newState = state.copyWith(
          status: AliasScreenStatus.loaded,
          isOffline: true,
          alias: alias,
        );
        _updateState(newState);
      } else {
        final newState = state.copyWith(
          status: AliasScreenStatus.failed,
          errorMessage: dioError.message.toString(),
        );
        _updateState(newState);
      }
    }
  }

  Future<void> editDescription(Alias alias, String newDesc) async {
    try {
      final updatedAlias =
          await aliasService.editAliasDescription(alias.id, newDesc);
      showToast(ToastMessage.editDescriptionSuccess);
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
      showToast(ToastMessage.deleteAliasSuccess);
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
      showToast(ToastMessage.restoreAliasSuccess);
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
      showToast(ToastMessage.forgetAliasSuccess);
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
      showToast(ToastMessage.sendFromAliasSuccess);
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
    }
  }
}
