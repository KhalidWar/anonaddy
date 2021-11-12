import 'package:anonaddy/models/username/username_model.dart';

enum UsernamesStatus { loading, loaded, failed }

class UsernamesState {
  const UsernamesState({
    required this.status,
    this.usernameModel,
    this.errorMessage,
  });

  final UsernamesStatus status;
  final UsernameModel? usernameModel;
  final String? errorMessage;

  UsernamesState copyWith({
    UsernamesStatus? status,
    UsernameModel? usernameModel,
    String? errorMessage,
  }) {
    return UsernamesState(
      status: status ?? this.status,
      usernameModel: usernameModel ?? this.usernameModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'UsernamesState{status: $status, usernameModel: $usernameModel, errorMessage: $errorMessage}';
  }
}
