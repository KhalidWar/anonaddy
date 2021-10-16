import 'package:anonaddy/models/alias/alias.dart';

enum AliasTabStatus { loading, loaded, failed }

class AliasTabState {
  const AliasTabState({
    required this.status,
    this.aliases,
    this.errorMessage,
  });

  final AliasTabStatus status;
  final List<Alias>? aliases;
  final String? errorMessage;

  AliasTabState copyWith({
    AliasTabStatus? status,
    List<Alias>? aliases,
    String? errorMessage,
  }) {
    return AliasTabState(
      status: status ?? this.status,
      aliases: aliases ?? this.aliases,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'AliasTabState{status: $status, aliases: $aliases, errorMessage: $errorMessage}';
  }
}
