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
}
