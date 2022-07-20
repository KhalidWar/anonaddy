import 'dart:io';

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

  final Function showToast = NicheMethod.showToast;

  void _updateState(UsernamesScreenState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchUsername(Username username) async {
    _updateState(state.copyWith(status: UsernamesScreenStatus.loading));
    try {
      final updatedUsername =
          await usernameService.getSpecificUsername(username.id);
      final newState = state.copyWith(
          status: UsernamesScreenStatus.loaded, username: updatedUsername);
      _updateState(newState);
    } on SocketException {
      /// Return old alias data if there's no internet connection
      final newState = state.copyWith(
          status: UsernamesScreenStatus.loaded, username: username);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      final newState = state.copyWith(
          status: UsernamesScreenStatus.failed, errorMessage: dioError.message);
      _updateState(newState);
    }
  }

  Future<void> addNewUsername(String username) async {
    try {
      await usernameService.addNewUsername(username);
      showToast('Username added successfully!');
      usernamesNotifier.fetchUsernames();
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
    }
  }

  Future<void> deleteUsername(Username username) async {
    try {
      await usernameService.deleteUsername(username.id);
      showToast('Username deleted successfully!');
      usernamesNotifier.fetchUsernames();
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
    }
  }

  Future updateUsernameDescription(
      Username username, String description) async {
    try {
      final newUsername = await usernameService.updateUsernameDescription(
          username.id, description);
      final updatedUsername =
          username.copyWith(description: newUsername.description);
      showToast('Description updated successfully!');
      _updateState(state.copyWith(username: updatedUsername));
    } on DioError catch (dioError) {
      showToast(dioError.message);
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
    }
  }

  Future updateDefaultRecipient(Username username, String recipientID) async {
    try {
      _updateState(state.copyWith(updateRecipientLoading: true));
      final newUsername = await usernameService.updateDefaultRecipient(
          username.id, recipientID);
      final updatedUsername =
          username.copyWith(defaultRecipient: newUsername.defaultRecipient);
      showToast('Default recipient updated successfully!');
      _updateState(state.copyWith(
        username: updatedUsername,
        updateRecipientLoading: false,
      ));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(updateRecipientLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
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
      showToast(dioError.message);
      _updateState(state.copyWith(activeSwitchLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
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
      showToast(dioError.message);
      _updateState(state.copyWith(activeSwitchLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
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
      showToast(dioError.message);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    }
  }

  Future<void> deactivateCatchAll(Username username) async {
    _updateState(state.copyWith(catchAllSwitchLoading: true));
    try {
      await usernameService.deactivateCatchAll(username.id);
      final updatedUsername = username.copyWith(catchAll: false);
      _updateState(state.copyWith(
        username: updatedUsername,
        catchAllSwitchLoading: false,
      ));
    } on DioError catch (dioError) {
      showToast(dioError.message);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    } catch (error) {
      showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    }
  }
}
