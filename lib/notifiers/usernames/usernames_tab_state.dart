import 'package:anonaddy/models/username/username.dart';

enum UsernamesStatus { loading, loaded, failed }

extension Shortcut on UsernamesStatus {
  bool get isFailed => this == UsernamesStatus.failed;
}

class UsernamesTabState {
  const UsernamesTabState({
    required this.status,
    required this.usernames,
    required this.errorMessage,
  });

  final UsernamesStatus status;
  final List<Username> usernames;
  final String errorMessage;

  static UsernamesTabState initialState() {
    return const UsernamesTabState(
      status: UsernamesStatus.loading,
      usernames: <Username>[],
      errorMessage: '',
    );
  }

  UsernamesTabState copyWith({
    UsernamesStatus? status,
    List<Username>? usernames,
    String? errorMessage,
  }) {
    return UsernamesTabState(
      status: status ?? this.status,
      usernames: usernames ?? this.usernames,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'UsernamesState{status: $status, usernames: $usernames, errorMessage: $errorMessage}';
  }
}
