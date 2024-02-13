import 'package:anonaddy/features/usernames/domain/username.dart';

class UsernamesScreenState {
  const UsernamesScreenState({
    required this.username,
    required this.activeSwitchLoading,
    required this.catchAllSwitchLoading,
    required this.updateRecipientLoading,
    required this.isOffline,
  });

  final Username username;
  final bool activeSwitchLoading;
  final bool catchAllSwitchLoading;
  final bool updateRecipientLoading;
  final bool isOffline;

  static UsernamesScreenState initialState() {
    return UsernamesScreenState(
      username: Username(),
      activeSwitchLoading: false,
      catchAllSwitchLoading: false,
      updateRecipientLoading: false,
      isOffline: false,
    );
  }

  UsernamesScreenState copyWith({
    Username? username,
    String? errorMessage,
    bool? activeSwitchLoading,
    bool? catchAllSwitchLoading,
    bool? updateRecipientLoading,
    bool? isOffline,
  }) {
    return UsernamesScreenState(
      username: username ?? this.username,
      activeSwitchLoading: activeSwitchLoading ?? this.activeSwitchLoading,
      catchAllSwitchLoading:
          catchAllSwitchLoading ?? this.catchAllSwitchLoading,
      updateRecipientLoading:
          updateRecipientLoading ?? this.updateRecipientLoading,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  String toString() {
    return 'UsernamesScreenState{username: $username, activeSwitchLoading: $activeSwitchLoading, catchAllSwitchLoading: $catchAllSwitchLoading, updateRecipientLoading: $updateRecipientLoading, isOffline: $isOffline}';
  }
}
