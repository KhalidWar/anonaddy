import 'package:anonaddy/models/username/username_model.dart';

enum UsernamesScreenStatus { loading, loaded, failed }

class UsernamesScreenState {
  const UsernamesScreenState({
    required this.status,
    this.username,
    this.errorMessage,
    this.activeSwitchLoading,
    this.catchAllSwitchLoading,
    this.updateRecipientLoading,
  });

  final UsernamesScreenStatus status;
  final Username? username;
  final String? errorMessage;

  final bool? activeSwitchLoading;
  final bool? catchAllSwitchLoading;
  final bool? updateRecipientLoading;

  static UsernamesScreenState initialState() {
    return UsernamesScreenState(
      status: UsernamesScreenStatus.loading,
      activeSwitchLoading: false,
      catchAllSwitchLoading: false,
      updateRecipientLoading: false,
    );
  }

  UsernamesScreenState copyWith({
    UsernamesScreenStatus? status,
    Username? username,
    String? errorMessage,
    bool? activeSwitchLoading,
    bool? catchAllSwitchLoading,
    bool? updateRecipientLoading,
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
    );
  }

  @override
  String toString() {
    return 'UsernamesScreenState{status: $status, username: $username, errorMessage: $errorMessage, activeSwitchLoading: $activeSwitchLoading, catchAllSwitchLoading: $catchAllSwitchLoading, updateRecipientLoading: $updateRecipientLoading}';
  }
}
