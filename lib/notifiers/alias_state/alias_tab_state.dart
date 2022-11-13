import 'package:anonaddy/models/alias/alias.dart';
import 'package:flutter/material.dart';

enum AliasTabStatus { loading, loaded, failed }

class AliasTabState {
  const AliasTabState({
    required this.status,
    required this.errorMessage,
    required this.availableAliasList,
    required this.deletedAliasList,
  });

  final AliasTabStatus status;
  final String errorMessage;
  final List<Alias> availableAliasList;
  final List<Alias> deletedAliasList;

  static AliasTabState initialState() {
    return const AliasTabState(
      status: AliasTabStatus.loading,
      errorMessage: '',
      availableAliasList: <Alias>[],
      deletedAliasList: <Alias>[],
    );
  }

  AliasTabState copyWith({
    AliasTabStatus? status,
    List<Alias>? aliases,
    String? errorMessage,
    List<Alias>? availableAliasList,
    GlobalKey<AnimatedListState>? availableListKey,
    List<Alias>? deletedAliasList,
  }) {
    return AliasTabState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      availableAliasList: availableAliasList ?? this.availableAliasList,
      deletedAliasList: deletedAliasList ?? this.deletedAliasList,
    );
  }

  @override
  String toString() {
    return 'AliasTabState{status: $status, errorMessage: $errorMessage, availableAliasList: $availableAliasList, deletedAliasList: $deletedAliasList}';
  }
}
