import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:flutter/material.dart';

enum AliasTabStatus { loading, loaded, failed }

class AliasTabState {
  const AliasTabState({
    required this.status,
    required this.aliases,
    required this.errorMessage,
    required this.availableAliasList,
    required this.deletedAliasList,
    required this.availableListKey,
  });

  final AliasTabStatus status;
  final List<Alias> aliases;
  final String errorMessage;

  final List<Alias> availableAliasList;
  final GlobalKey<AnimatedListState> availableListKey;
  final List<Alias> deletedAliasList;

  static AliasTabState initialState() {
    return AliasTabState(
      status: AliasTabStatus.loading,
      aliases: const <Alias>[],
      errorMessage: AppStrings.somethingWentWrong,
      availableAliasList: const <Alias>[],
      availableListKey: GlobalKey<AnimatedListState>(),
      deletedAliasList: const <Alias>[],
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
      availableListKey: availableListKey ?? this.availableListKey,
      deletedAliasList: deletedAliasList ?? this.deletedAliasList,
    );
  }

  @override
  String toString() {
    return 'AliasTabState{status: $status, aliases: $aliases, errorMessage: $errorMessage, availableAliasList: $availableAliasList, availableListKey: $availableListKey, deletedAliasList: $deletedAliasList}';
  }
}
