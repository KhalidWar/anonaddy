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
    aliasService: ref.read(aliasServiceProvider),
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

  /// Update AliasScreen state
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
          errorMessage: dioError.message,
        );
        _updateState(newState);
      }
    }
  }

  Future<void> editDescription(Alias alias, String newDesc) async {
    try {
      final updatedAlias =
          await aliasService.updateAliasDescription(alias.id, newDesc);
      showToast(ToastMessage.editDescriptionSuccess);
      _updateState(state.copyWith(alias: updatedAlias));
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
    }
  }

  Future<void> deactivateAlias(String aliasId) async {
    try {
      _updateState(state.copyWith(isToggleLoading: true));
      await aliasService.deactivateAlias(aliasId);
      final updatedAlias = state.alias!.copyWith(active: false);
      _updateState(state.copyWith(isToggleLoading: false, alias: updatedAlias));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(isToggleLoading: false));
    } catch (error) {
      showToast(error.toString());
      _updateState(state.copyWith(isToggleLoading: false));
    }
  }

  Future<void> activateAlias(String aliasId) async {
    try {
      _updateState(state.copyWith(isToggleLoading: true));
      final newAlias = await aliasService.activateAlias(aliasId);
      final updateAlias = state.alias!.copyWith(active: newAlias.active);
      _updateState(state.copyWith(isToggleLoading: false, alias: updateAlias));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(isToggleLoading: false));
    } catch (error) {
      showToast(error.toString());
      _updateState(state.copyWith(isToggleLoading: false));
    }
  }

  Future<void> deleteAlias(String aliasId) async {
    try {
      _updateState(state.copyWith(deleteAliasLoading: true));
      await aliasService.deleteAlias(aliasId);
      showToast(ToastMessage.deleteAliasSuccess);
      final updatedAlias = state.alias!.copyWith(deletedAt: '');
      aliasTabNotifier.refreshAliases();

      final newState =
          state.copyWith(deleteAliasLoading: false, alias: updatedAlias);
      _updateState(newState);
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(deleteAliasLoading: false));
    } catch (error) {
      showToast(error.toString());
      _updateState(state.copyWith(deleteAliasLoading: false));
    }
  }

  Future<void> restoreAlias(String aliasId) async {
    try {
      _updateState(state.copyWith(deleteAliasLoading: true));
      final newAlias = await aliasService.restoreAlias(aliasId);
      showToast(ToastMessage.restoreAliasSuccess);
      aliasTabNotifier.refreshAliases();

      final newState =
          state.copyWith(deleteAliasLoading: false, alias: newAlias);
      _updateState(newState);
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(deleteAliasLoading: false));
    } catch (error) {
      showToast(error.toString());
      _updateState(state.copyWith(deleteAliasLoading: false));
    }
  }

  Future<void> updateAliasDefaultRecipient(
      Alias alias, List<String> recipients) async {
    _updateState(state.copyWith(updateRecipientLoading: true));
    try {
      final updatedAlias =
          await aliasService.updateAliasDefaultRecipient(alias.id, recipients);
      final newState =
          state.copyWith(updateRecipientLoading: false, alias: updatedAlias);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
    }
    _updateState(state.copyWith(updateRecipientLoading: false));
  }

  Future<void> forgetAlias(String aliasID) async {
    try {
      await aliasService.forgetAlias(aliasID);
      showToast(ToastMessage.forgetAliasSuccess);
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
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
