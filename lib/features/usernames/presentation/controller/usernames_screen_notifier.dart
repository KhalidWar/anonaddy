import 'dart:async';

import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/usernames/data/username_screen_service.dart';
import 'package:anonaddy/features/usernames/domain/username.dart';
import 'package:anonaddy/features/usernames/presentation/controller/usernames_notifier.dart';
import 'package:anonaddy/features/usernames/presentation/controller/usernames_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernamesScreenNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<UsernamesScreenNotifier, UsernamesScreenState, String>(
        UsernamesScreenNotifier.new);

class UsernamesScreenNotifier
    extends AutoDisposeFamilyAsyncNotifier<UsernamesScreenState, String> {
  Future<void> fetchSpecificUsername(String id) async {
    try {
      final currentState = state.value!;
      state = const AsyncLoading();
      final updatedUsername = await ref
          .read(usernameScreenServiceProvider)
          .fetchSpecificUsername(id);
      state = AsyncData(currentState.copyWith(username: updatedUsername));
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.empty);
    }
  }

  Future<void> deleteUsername(String usernameId) async {
    try {
      await ref.read(usernameScreenServiceProvider).deleteUsername(usernameId);
      Utilities.showToast('Username deleted successfully!');
      ref.read(usernamesNotifierProvider.notifier).fetchUsernames();
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future updateUsernameDescription(
    Username username,
    String description,
  ) async {
    try {
      final newUsername = await ref
          .read(usernameScreenServiceProvider)
          .updateUsernameDescription(username.id, description);
      final updatedUsername =
          username.copyWith(description: newUsername.description);
      Utilities.showToast('Description updated successfully!');
      state = AsyncData(state.value!.copyWith(username: updatedUsername));
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future updateDefaultRecipient(Username username, String? recipientID) async {
    try {
      final currentState = state.value!;

      state = AsyncData(currentState.copyWith(updateRecipientLoading: true));
      await ref
          .read(usernameScreenServiceProvider)
          .updateDefaultRecipient(username.id, recipientID);
      Utilities.showToast('Default recipient updated successfully!');

      final updatedUsername = await ref
          .read(usernameScreenServiceProvider)
          .fetchSpecificUsername(username.id);
      state = AsyncData(currentState.copyWith(
        username: updatedUsername,
        updateRecipientLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(updateRecipientLoading: false));
    }
  }

  Future<void> activateUsername(Username username) async {
    try {
      state = AsyncData(state.value!.copyWith(activeSwitchLoading: true));
      final newUsername = await ref
          .read(usernameScreenServiceProvider)
          .activateUsername(username.id);
      final updatedUsername = username.copyWith(active: newUsername.active);
      state = AsyncData(state.value!.copyWith(
        username: updatedUsername,
        activeSwitchLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(activeSwitchLoading: false));
    }
  }

  Future<void> deactivateUsername(Username username) async {
    try {
      state = AsyncData(state.value!.copyWith(activeSwitchLoading: true));
      await ref
          .read(usernameScreenServiceProvider)
          .deactivateUsername(username.id);
      final updatedUsername = username.copyWith(active: false);
      state = AsyncData(state.value!.copyWith(
        username: updatedUsername,
        activeSwitchLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(activeSwitchLoading: false));
    }
  }

  Future<void> activateCatchAll(Username username) async {
    try {
      state = AsyncData(state.value!.copyWith(catchAllSwitchLoading: true));
      final newUsername = await ref
          .read(usernameScreenServiceProvider)
          .activateCatchAll(username.id);
      final updatedUsername = username.copyWith(catchAll: newUsername.catchAll);
      state = AsyncData(state.value!.copyWith(
        username: updatedUsername,
        catchAllSwitchLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(catchAllSwitchLoading: false));
    }
  }

  Future<void> deactivateCatchAll(Username username) async {
    try {
      state = AsyncData(state.value!.copyWith(catchAllSwitchLoading: true));
      await ref
          .read(usernameScreenServiceProvider)
          .deactivateCatchAll(username.id);
      final updatedUsername = username.copyWith(catchAll: false);
      state = AsyncData(state.value!.copyWith(
        username: updatedUsername,
        catchAllSwitchLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(catchAllSwitchLoading: false));
    }
  }

  @override
  FutureOr<UsernamesScreenState> build(String arg) async {
    final service = ref.read(usernameScreenServiceProvider);

    final username = await service.fetchSpecificUsername(arg);

    return UsernamesScreenState(
      username: username,
      activeSwitchLoading: false,
      catchAllSwitchLoading: false,
      updateRecipientLoading: false,
    );
  }
}
