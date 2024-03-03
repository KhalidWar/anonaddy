import 'package:anonaddy/features/aliases/domain/alias.dart';

class AliasesState {
  const AliasesState({
    required this.availableAliases,
    required this.deletedAliases,
  });

  final List<Alias> availableAliases;
  final List<Alias> deletedAliases;

  static AliasesState initialState() {
    return const AliasesState(
      availableAliases: <Alias>[],
      deletedAliases: <Alias>[],
    );
  }

  AliasesState copyWith({
    List<Alias>? availableAliases,
    List<Alias>? deletedAliases,
  }) {
    return AliasesState(
      availableAliases: availableAliases ?? this.availableAliases,
      deletedAliases: deletedAliases ?? this.deletedAliases,
    );
  }

  @override
  String toString() {
    return 'AliasTabState{availableAliases: $availableAliases, deletedAliases: $deletedAliases}';
  }
}
