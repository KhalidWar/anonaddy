import 'package:anonaddy/models/username/username.dart';
import 'package:anonaddy/notifiers/usernames/usernames_screen_state.dart';
import 'package:anonaddy/notifiers/usernames/usernames_tab_notifier.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:anonaddy/utilities/utilities.dart';
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

  Future<void> fetchSpecificUsername(String id) async {
    try {
      _updateState(state.copyWith(status: UsernamesScreenStatus.loading));
      final updatedUsername = await usernameService.fetchSpecificUsername(id);
      final newState = state.copyWith(
          status: UsernamesScreenStatus.loaded, username: updatedUsername);
      _updateState(newState);
    } catch (error) {
      _updateState(state.copyWith(
        status: UsernamesScreenStatus.failed,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> addNewUsername(String username) async {
    try {
      await usernameService.addNewUsername(username);
      Utilities.showToast('Username added successfully!');
      usernamesNotifier.fetchUsernames();
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> deleteUsername(Username username) async {
    try {
      await usernameService.deleteUsername(username.id);
      Utilities.showToast('Username deleted successfully!');
      usernamesNotifier.fetchUsernames();
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future updateUsernameDescription(
      Username username, String description) async {
    try {
      final newUsername = await usernameService.updateUsernameDescription(
          username.id, description);
      final updatedUsername =
          username.copyWith(description: newUsername.description);
      Utilities.showToast('Description updated successfully!');
      _updateState(state.copyWith(username: updatedUsername));
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future updateDefaultRecipient(Username username, String recipientID) async {
    try {
      _updateState(state.copyWith(updateRecipientLoading: true));
      final newUsername = await usernameService.updateDefaultRecipient(
          username.id, recipientID);
      final updatedUsername =
          username.copyWith(defaultRecipient: newUsername.defaultRecipient);
      Utilities.showToast('Default recipient updated successfully!');
      _updateState(state.copyWith(
        username: updatedUsername,
        updateRecipientLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
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
    } catch (error) {
      Utilities.showToast(error.toString());
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
    } catch (error) {
      Utilities.showToast(error.toString());
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
    } catch (error) {
      Utilities.showToast(error.toString());
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
    } catch (error) {
      Utilities.showToast(error.toString());
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    }
  }
}
