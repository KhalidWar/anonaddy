import 'package:anonaddy/models/alias/alias.dart';
import 'package:flutter/material.dart';

enum AliasTabStatus { loading, loaded, failed }

class AliasTabState {
  const AliasTabState({
    required this.status,
    required this.aliases,
    required this.errorMessage,
    required this.availableAliasList,
    required this.deletedAliasList,
  });

  final AliasTabStatus status;
  final List<Alias> aliases;
  final String errorMessage;
  final List<Alias> availableAliasList;
  final List<Alias> deletedAliasList;

  static AliasTabState initialState() {
    return const AliasTabState(
      status: AliasTabStatus.loading,
      aliases: <Alias>[],
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
      aliases: aliases ?? this.aliases,
      errorMessage: errorMessage ?? this.errorMessage,
      availableAliasList: availableAliasList ?? this.availableAliasList,
      deletedAliasList: deletedAliasList ?? this.deletedAliasList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.index,
      'aliases': aliases,
      'errorMessage': errorMessage,
      'availableAliasList': availableAliasList,
      'deletedAliasList': deletedAliasList,
    };
  }

  factory AliasTabState.fromMap(Map<String, dynamic> map) {
    List<Alias> convertMaps(List<dynamic> list) {
      return list.map((alias) => Alias.fromJson(alias)).toList();
    }

    return AliasTabState(
      status: AliasTabStatus.values[map['status']],
      aliases: convertMaps(map['aliases']),
      errorMessage: map['errorMessage'] as String,
      availableAliasList: convertMaps(map['availableAliasList']),
      deletedAliasList: convertMaps(map['deletedAliasList']),
    );
  }

  @override
  String toString() {
    return 'AliasTabState{status: $status, aliases: $aliases, errorMessage: $errorMessage, availableAliasList: $availableAliasList, deletedAliasList: $deletedAliasList}';
  }
}
