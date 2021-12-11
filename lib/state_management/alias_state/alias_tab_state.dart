import 'package:anonaddy/models/alias/alias.dart';

enum AliasTabStatus { loading, loaded, failed }

class AliasTabState {
  const AliasTabState({
    required this.status,
    this.aliases,
    this.errorMessage,
    required this.availableAliasList,
    required this.deletedAliasList,
  });

  final AliasTabStatus status;
  final List<Alias>? aliases;
  final String? errorMessage;

  final List<Alias> availableAliasList;
  final List<Alias> deletedAliasList;

  static AliasTabState initialState() {
    return AliasTabState(
      status: AliasTabStatus.loading,
      aliases: [],
      availableAliasList: [],
      deletedAliasList: [],
    );
  }

  AliasTabState copyWith({
    AliasTabStatus? status,
    List<Alias>? aliases,
    String? errorMessage,
    List<Alias>? availableAliasList,
    List<Alias>? deletedAliasList,
  }) {
    return AliasTabState(
      status: status ?? this.status,
      aliases: aliases ?? this.aliases,
      errorMessage: errorMessage ?? this.errorMessage,
      availableAliasList: availableAliasList ?? this.availableAliasList,
      deletedAliasList: deletedAliasList ?? this.deletedAliasList,
    );
  }

  @override
  String toString() {
    return 'AliasTabState{status: $status, aliases: $aliases, errorMessage: $errorMessage, availableAliasList: $availableAliasList, deletedAliasList: $deletedAliasList}';
  }
}
