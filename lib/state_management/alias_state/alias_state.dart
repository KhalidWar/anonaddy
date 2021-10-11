import 'package:anonaddy/models/alias/alias.dart';

enum AliasStatus { loading, loaded, failed }

class AliasState {
  const AliasState({
    required this.status,
    this.aliases,
    this.errorMessage,
  });

  final AliasStatus status;
  final List<Alias>? aliases;
  final String? errorMessage;
}
