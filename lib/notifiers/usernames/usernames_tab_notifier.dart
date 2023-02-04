import 'package:anonaddy/notifiers/usernames/usernames_tab_state.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameStateNotifier =
    StateNotifierProvider.autoDispose<UsernamesNotifier, UsernamesTabState>(
        (ref) {
  return UsernamesNotifier(
    usernameService: ref.read(usernameServiceProvider),
  );
});

class UsernamesNotifier extends StateNotifier<UsernamesTabState> {
  UsernamesNotifier({
    required this.usernameService,
  }) : super(UsernamesTabState.initialState());

  final UsernameService usernameService;

  /// Updates Usernames state
  void _updateState(UsernamesTabState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchUsernames() async {
    try {
      final domains = await usernameService.fetchUsernames();
      final newState = state.copyWith(
        status: UsernamesStatus.loaded,
        usernames: domains,
      );
      _updateState(newState);
    } catch (error) {
      _updateState(state.copyWith(
        status: UsernamesStatus.failed,
        errorMessage: error.toString(),
      ));
      await _retryOnError();
    }
  }

  Future<void> _retryOnError() async {
    if (state.status.isFailed) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchUsernames();
    }
  }

  /// Fetches recipients from disk and displays them, used at initial app
  /// startup since fetching from disk is a lot faster than fetching from API.
  /// It's also used to when there's no internet connection.
  Future<void> loadOfflineState() async {
    try {
      final usernames = await usernameService.loadUsernameFromDisk();
      _updateState(
        state.copyWith(status: UsernamesStatus.loaded, usernames: usernames),
      );
    } catch (error) {
      return;
    }
  }
}
