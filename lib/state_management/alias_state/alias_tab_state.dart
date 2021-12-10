import 'package:anonaddy/models/alias/alias.dart';

enum AliasTabStatus { loading, loaded, failed }

class AliasTabState {
  const AliasTabState({
    required this.status,
    this.aliases,
    this.errorMessage,
    required this.availableAliasList,
    required this.deletedAliasList,
    required this.forwardedList,
    required this.blockedList,
    required this.repliedList,
    required this.sentList,
  });

  final AliasTabStatus status;
  final List<Alias>? aliases;
  final String? errorMessage;

  final List<Alias> availableAliasList;
  final List<Alias> deletedAliasList;
  final int forwardedList;
  final int blockedList;
  final int repliedList;
  final int sentList;

  static AliasTabState initialState() {
    return AliasTabState(
      status: AliasTabStatus.loading,
      aliases: [],
      availableAliasList: [],
      deletedAliasList: [],
      forwardedList: 0,
      blockedList: 0,
      repliedList: 0,
      sentList: 0,
    );
  }

  AliasTabState copyWith({
    AliasTabStatus? status,
    List<Alias>? aliases,
    String? errorMessage,
    List<Alias>? availableAliasList,
    List<Alias>? deletedAliasList,
    int? forwardedList,
    int? blockedList,
    int? repliedList,
    int? sentList,
  }) {
    return AliasTabState(
      status: status ?? this.status,
      aliases: aliases ?? this.aliases,
      errorMessage: errorMessage ?? this.errorMessage,
      availableAliasList: availableAliasList ?? this.availableAliasList,
      deletedAliasList: deletedAliasList ?? this.deletedAliasList,
      forwardedList: forwardedList ?? this.forwardedList,
      blockedList: blockedList ?? this.blockedList,
      repliedList: repliedList ?? this.repliedList,
      sentList: sentList ?? this.sentList,
    );
  }

  @override
  String toString() {
    return 'AliasTabState{status: $status, aliases: $aliases, errorMessage: $errorMessage, availableAliasList: $availableAliasList, deletedAliasList: $deletedAliasList, forwardedList: $forwardedList, blockedList: $blockedList, repliedList: $repliedList, sentList: $sentList}';
  }
}
