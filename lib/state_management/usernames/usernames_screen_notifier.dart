import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:anonaddy/state_management/usernames/usernames_screen_state.dart';
import 'package:anonaddy/state_management/usernames/usernames_tab_notifier.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernamesScreenStateNotifier = StateNotifierProvider.autoDispose<
    UsernamesScreenNotifier, UsernamesScreenState>((ref) {
  return UsernamesScreenNotifier(
    usernameService: ref.read(usernameService),
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

  Future<void> fetchUsername(Username username) async {
    state = state.copyWith(status: UsernamesScreenStatus.loading);
    try {
      final updatedUsername =
          await usernameService.getSpecificUsername(username.id);
      state = state.copyWith(
          status: UsernamesScreenStatus.loaded, username: updatedUsername);
    } on SocketException {
      /// Return old alias data if there's no internet connection
      state = state.copyWith(
          status: UsernamesScreenStatus.loaded, username: username);
    } catch (error) {
      state = state.copyWith(
        status: UsernamesScreenStatus.failed,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> createNewUsername(String username) async {
    try {
      await usernameService.createNewUsername(username);
      showToast('Username added successfully!');
      usernamesNotifier.fetchUsernames();
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> deleteUsername(Username username) async {
    try {
      await usernameService.deleteUsername(username.id);
      showToast('Username deleted successfully!');
      usernamesNotifier.fetchUsernames();
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future editDescription(Username username, String description) async {
    try {
      final newUsername = await usernameService.editUsernameDescription(
          username.id, description);
      state.username!.description = newUsername.description;
      showToast('Description updated successfully!');
      state = state.copyWith();
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future updateDefaultRecipient(Username username, String recipientID) async {
    state = state.copyWith(updateRecipientLoading: true);
    try {
      final newUsername = await usernameService.updateDefaultRecipient(
          username.id, recipientID);
      state.username!.defaultRecipient = newUsername.defaultRecipient;
      showToast('Default recipient updated successfully!');
      state = state.copyWith(updateRecipientLoading: false);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(updateRecipientLoading: false);
    }
  }

  Future<void> activateUsername(Username username) async {
    state = state.copyWith(activeSwitchLoading: true);
    try {
      final newUsername = await usernameService.activateUsername(username.id);
      state.username!.active = newUsername.active;
      state = state.copyWith(activeSwitchLoading: false);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(activeSwitchLoading: false);
    }
  }

  Future<void> deactivateUsername(Username username) async {
    state = state.copyWith(activeSwitchLoading: true);
    try {
      await usernameService.deactivateUsername(username.id);
      username.active = false;
      state = state.copyWith(activeSwitchLoading: false);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(activeSwitchLoading: false);
    }
  }

  Future<void> activateCatchAll(Username username) async {
    state = state.copyWith(catchAllSwitchLoading: true);
    try {
      final newUsername = await usernameService.activateCatchAll(username.id);
      state.username!.catchAll = newUsername.catchAll;
      state = state.copyWith(catchAllSwitchLoading: false);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(catchAllSwitchLoading: false);
    }
  }

  Future<void> deactivateCatchAll(Username username) async {
    state = state.copyWith(catchAllSwitchLoading: true);
    try {
      await usernameService.deactivateCatchAll(username.id);
      state.username!.catchAll = false;
      state = state.copyWith(catchAllSwitchLoading: false);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(catchAllSwitchLoading: false);
    }
  }
}
