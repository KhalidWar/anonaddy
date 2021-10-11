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
}
