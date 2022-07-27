import 'package:anonaddy/models/username/username.dart';

enum UsernamesScreenStatus { loading, loaded, failed }

class UsernamesScreenState {
  const UsernamesScreenState({
    required this.status,
    required this.username,
    required this.errorMessage,
    required this.activeSwitchLoading,
    required this.catchAllSwitchLoading,
    required this.updateRecipientLoading,
    required this.isOffline,
  });

  final UsernamesScreenStatus status;
  final Username username;
  final String errorMessage;

  final bool activeSwitchLoading;
  final bool catchAllSwitchLoading;
  final bool updateRecipientLoading;
  final bool isOffline;

  static UsernamesScreenState initialState() {
    return UsernamesScreenState(
      status: UsernamesScreenStatus.loading,
      username: Username(),
      activeSwitchLoading: false,
      catchAllSwitchLoading: false,
      updateRecipientLoading: false,
      errorMessage: '',
      isOffline: false,
    );
  }

  UsernamesScreenState copyWith({
    UsernamesScreenStatus? status,
    Username? username,
    String? errorMessage,
    bool? activeSwitchLoading,
    bool? catchAllSwitchLoading,
    bool? updateRecipientLoading,
    bool? isOffline,
  }) {
    return UsernamesScreenState(
      status: status ?? this.status,
      username: username ?? this.username,
      errorMessage: errorMessage ?? this.errorMessage,
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
    return 'UsernamesScreenState{status: $status, username: $username, errorMessage: $errorMessage, activeSwitchLoading: $activeSwitchLoading, catchAllSwitchLoading: $catchAllSwitchLoading, updateRecipientLoading: $updateRecipientLoading, isOffline: $isOffline}';
  }
}
