import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/notifiers/alias_state/alias_screen_state.dart';
import 'package:anonaddy/notifiers/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasScreenStateNotifier =
    StateNotifierProvider.autoDispose<AliasScreenNotifier, AliasScreenState>(
        (ref) {
  final aliasTab = ref.read(aliasTabStateNotifier.notifier);
  ref.onDispose(() => aliasTab.refreshAliases());

  return AliasScreenNotifier(
    aliasService: ref.read(aliasServiceProvider),
    aliasTabNotifier: aliasTab,
  );
});

class AliasScreenNotifier extends StateNotifier<AliasScreenState> {
  AliasScreenNotifier({
    required this.aliasService,
    required this.aliasTabNotifier,
    AliasScreenState? initialState,
  }) : super(initialState ?? AliasScreenState.initialState());

  final AliasService aliasService;
  final AliasTabNotifier aliasTabNotifier;

  /// Update AliasScreen state
  void _updateState(AliasScreenState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchSpecificAlias(Alias alias) async {
    /// Initially set AliasScreen to loading
    try {
      _updateState(state.copyWith(status: AliasScreenStatus.loading));

      final updatedAlias = await aliasService.getSpecificAlias(alias.id);

      /// Assign newly fetched alias data to AliasScreen state
      final newState =
          state.copyWith(status: AliasScreenStatus.loaded, alias: updatedAlias);
      _updateState(newState);
    } catch (error) {
      final newState = state.copyWith(
        status: AliasScreenStatus.failed,
        errorMessage: AppStrings.somethingWentWrong,
      );
      _updateState(newState);
    }
  }

  Future<void> editDescription(String newDesc) async {
    try {
      final updatedAlias =
          await aliasService.updateAliasDescription(state.alias.id, newDesc);
      Utilities.showToast(ToastMessage.editDescriptionSuccess);
      _updateState(state.copyWith(alias: updatedAlias));
    } catch (error) {
      final dioError = error as DioError;
      Utilities.showToast(dioError.message);
    }
  }

  Future<void> deactivateAlias() async {
    try {
      _updateState(state.copyWith(isToggleLoading: true));
      await aliasService.deactivateAlias(state.alias.id);
      final updatedAlias = state.alias.copyWith(active: false);
      _updateState(state.copyWith(isToggleLoading: false, alias: updatedAlias));
    } on DioError catch (dioError) {
      Utilities.showToast(dioError.message);
      _updateState(state.copyWith(isToggleLoading: false));
    } catch (error) {
      Utilities.showToast(error.toString());
      _updateState(state.copyWith(isToggleLoading: false));
    }
  }

  Future<void> activateAlias() async {
    try {
      _updateState(state.copyWith(isToggleLoading: true));
      final newAlias = await aliasService.activateAlias(state.alias.id);
      final updateAlias = state.alias.copyWith(active: newAlias.active);
      _updateState(state.copyWith(isToggleLoading: false, alias: updateAlias));
    } on DioError catch (dioError) {
      Utilities.showToast(dioError.message);
      _updateState(state.copyWith(isToggleLoading: false));
    } catch (error) {
      Utilities.showToast(error.toString());
      _updateState(state.copyWith(isToggleLoading: false));
    }
  }

  Future<void> deleteAlias(Alias alias) async {
    try {
      _updateState(state.copyWith(deleteAliasLoading: true));
      await aliasService.deleteAlias(alias.id);
      Utilities.showToast(ToastMessage.deleteAliasSuccess);
      final updatedAlias = state.alias.copyWith(deletedAt: '');
      aliasTabNotifier.removeDeletedAlias(alias);

      final newState =
          state.copyWith(deleteAliasLoading: false, alias: updatedAlias);
      _updateState(newState);
    } on DioError catch (dioError) {
      Utilities.showToast(dioError.message);
      _updateState(state.copyWith(deleteAliasLoading: false));
    } catch (error) {
      Utilities.showToast(error.toString());
      _updateState(state.copyWith(deleteAliasLoading: false));
    }
  }

  Future<void> restoreAlias(Alias alias) async {
    try {
      _updateState(state.copyWith(deleteAliasLoading: true));
      final newAlias = await aliasService.restoreAlias(alias.id);
      Utilities.showToast(ToastMessage.restoreAliasSuccess);
      aliasTabNotifier.removeRestoredAlias(alias);

      final newState =
          state.copyWith(deleteAliasLoading: false, alias: newAlias);
      _updateState(newState);
    } on DioError catch (dioError) {
      Utilities.showToast(dioError.message);
      _updateState(state.copyWith(deleteAliasLoading: false));
    } catch (error) {
      Utilities.showToast(error.toString());
      _updateState(state.copyWith(deleteAliasLoading: false));
    }
  }

  Future<void> updateAliasDefaultRecipient(List<String> recipients) async {
    _updateState(state.copyWith(updateRecipientLoading: true));
    try {
      final updatedAlias = await aliasService.updateAliasDefaultRecipient(
          state.alias.id, recipients);
      final newState =
          state.copyWith(updateRecipientLoading: false, alias: updatedAlias);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      Utilities.showToast(dioError.message);
    }
    _updateState(state.copyWith(updateRecipientLoading: false));
  }

  Future<void> forgetAlias() async {
    try {
      await aliasService.forgetAlias(state.alias.id);
      Utilities.showToast(ToastMessage.forgetAliasSuccess);
    } catch (error) {
      final dioError = error as DioError;
      Utilities.showToast(dioError.message);
    }
  }

  Future<void> sendFromAlias(String destinationEmail) async {
    /// https://anonaddy.com/help/sending-email-from-an-alias/
    final leftPartOfAlias = state.alias.email.split('@')[0];
    final rightPartOfAlias = state.alias.email.split('@')[1];
    final recipientEmail = destinationEmail.replaceAll('@', '=');
    final generatedAddress =
        '$leftPartOfAlias+$recipientEmail@$rightPartOfAlias';

    try {
      await Utilities.copyOnTap(generatedAddress);
      Utilities.showToast(ToastMessage.sendFromAliasSuccess);
    } catch (error) {
      Utilities.showToast(AppStrings.somethingWentWrong);
    }
  }
}
