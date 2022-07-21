import 'package:anonaddy/models/username/username.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/state_management/usernames/usernames_screen_state.dart';
import 'package:anonaddy/state_management/usernames/usernames_tab_notifier.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernamesScreenStateNotifier = StateNotifierProvider.autoDispose<
    UsernamesScreenNotifier, UsernamesScreenState>((ref) {
  return UsernamesScreenNotifier(
    usernameService: ref.read(usernameServiceProvider),
    usernamesNotifier: ref.read(usernameStateNotifier.notifier),
  );
});

class UsernamesScreenNotifier extends StateNotifier<UsernamesScreenState> {
  UsernamesScreenNotifier({
    required this.usernameService,
    required this.usernamesNotifier,
  }) : super(UsernamesScreenState.initialState());

  final UsernameService usernameService;
  final UsernamesNotifier usernamesNotifier;

  void _updateState(UsernamesScreenState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchUsername(Username username) async {
    try {
      _updateState(state.copyWith(status: UsernamesScreenStatus.loading));
      final updatedUsername =
          await usernameService.getSpecificUsername(username.id);
      final newState = state.copyWith(
          status: UsernamesScreenStatus.loaded, username: updatedUsername);
      _updateState(newState);
    } on DioError catch (dioError) {
      /// Return old username data if offline
      if (dioError.type == DioErrorType.other) {
        _updateState(state.copyWith(
          status: UsernamesScreenStatus.loaded,
          username: username,
          isOffline: true,
        ));
      } else {
        _updateState(state.copyWith(
          status: UsernamesScreenStatus.failed,
          errorMessage: dioError.message,
        ));
      }
    } catch (error) {
      _updateState(state.copyWith(
        status: UsernamesScreenStatus.failed,
        errorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }

  Future<void> addNewUsername(String username) async {
    try {
      await usernameService.addNewUsername(username);
      NicheMethod.showToast('Username added successfully!');
      usernamesNotifier.fetchUsernames();
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }

  Future<void> deleteUsername(Username username) async {
    try {
      await usernameService.deleteUsername(username.id);
      NicheMethod.showToast('Username deleted successfully!');
      usernamesNotifier.fetchUsernames();
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }

  Future updateUsernameDescription(
      Username username, String description) async {
    try {
      final newUsername = await usernameService.updateUsernameDescription(
          username.id, description);
      final updatedUsername =
          username.copyWith(description: newUsername.description);
      NicheMethod.showToast('Description updated successfully!');
      _updateState(state.copyWith(username: updatedUsername));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }

  Future updateDefaultRecipient(Username username, String recipientID) async {
    try {
      _updateState(state.copyWith(updateRecipientLoading: true));
      final newUsername = await usernameService.updateDefaultRecipient(
          username.id, recipientID);
      final updatedUsername =
          username.copyWith(defaultRecipient: newUsername.defaultRecipient);
      NicheMethod.showToast('Default recipient updated successfully!');
      _updateState(state.copyWith(
        username: updatedUsername,
        updateRecipientLoading: false,
      ));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
      _updateState(state.copyWith(updateRecipientLoading: false));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(updateRecipientLoading: false));
    }
  }

  Future<void> activateUsername(Username username) async {
    try {
      _updateState(state.copyWith(activeSwitchLoading: true));
      final newUsername = await usernameService.activateUsername(username.id);
      final updatedUsername = username.copyWith(active: newUsername.active);
      _updateState(state.copyWith(
        username: updatedUsername,
        activeSwitchLoading: false,
      ));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
      _updateState(state.copyWith(activeSwitchLoading: false));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(activeSwitchLoading: false));
    }
  }

  Future<void> deactivateUsername(Username username) async {
    try {
      _updateState(state.copyWith(activeSwitchLoading: true));
      await usernameService.deactivateUsername(username.id);
      final updatedUsername = username.copyWith(active: false);
      _updateState(state.copyWith(
        username: updatedUsername,
        activeSwitchLoading: false,
      ));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
      _updateState(state.copyWith(activeSwitchLoading: false));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(activeSwitchLoading: false));
    }
  }

  Future<void> activateCatchAll(Username username) async {
    try {
      _updateState(state.copyWith(catchAllSwitchLoading: true));
      final newUsername = await usernameService.activateCatchAll(username.id);
      final updatedUsername = username.copyWith(catchAll: newUsername.catchAll);
      _updateState(state.copyWith(
        username: updatedUsername,
        catchAllSwitchLoading: false,
      ));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    }
  }

  Future<void> deactivateCatchAll(Username username) async {
    try {
      _updateState(state.copyWith(catchAllSwitchLoading: true));
      await usernameService.deactivateCatchAll(username.id);
      final updatedUsername = username.copyWith(catchAll: false);
      _updateState(state.copyWith(
        username: updatedUsername,
        catchAllSwitchLoading: false,
      ));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    }
  }
}
