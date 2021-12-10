import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/state_management/lifecycle/lifecycle_state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';
import 'alias_tab_state.dart';

final aliasTabStateNotifier =
    StateNotifierProvider<AliasTabNotifier, AliasTabState>((ref) {
  return AliasTabNotifier(
    aliasService: ref.read(aliasService),
    offlineData: ref.read(offlineDataProvider),
    lifecycleStatus: ref.watch(lifecycleStateNotifier),
  );
});

class AliasTabNotifier extends StateNotifier<AliasTabState> {
  AliasTabNotifier({
    required this.aliasService,
    required this.offlineData,
    required this.lifecycleStatus,
  }) : super(AliasTabState.initialState()) {
    _setOfflineState();
    fetchAliases();
  }

  final AliasService aliasService;
  final OfflineData offlineData;
  final LifecycleStatus lifecycleStatus;

  Future<void> fetchAliases() async {
    try {
      while (lifecycleStatus == LifecycleStatus.foreground) {
        final aliases = await aliasService.getAllAliasesData();
        await _saveOfflineData(aliases);

        final availableAliasList = <Alias>[];
        final deletedAliasList = <Alias>[];
        final forwardedList = <int>[];
        final blockedList = <int>[];
        final repliedList = <int>[];
        final sentList = <int>[];

        for (Alias alias in aliases) {
          forwardedList.add(alias.emailsForwarded);
          blockedList.add(alias.emailsBlocked);
          repliedList.add(alias.emailsReplied);
          sentList.add(alias.emailsSent);

          if (alias.deletedAt == null) {
            availableAliasList.add(alias);
          } else {
            deletedAliasList.add(alias);
          }
        }

        state = state.copyWith(
          status: AliasTabStatus.loaded,
          aliases: aliases,
          availableAliasList: availableAliasList,
          deletedAliasList: deletedAliasList,
          forwardedList: _reduceList(forwardedList),
          blockedList: _reduceList(blockedList),
          repliedList: _reduceList(repliedList),
          sentList: _reduceList(sentList),
        );
        await Future.delayed(Duration(seconds: 1));
      }
    } on SocketException {
      _setOfflineState();
    } catch (error) {
      if (mounted) {
        state = state.copyWith(
          status: AliasTabStatus.failed,
          errorMessage: error.toString(),
        );
        await _retryOnError();
      }
    }
  }

  Future _retryOnError() async {
    if (state.status == AliasTabStatus.failed) {
      await Future.delayed(Duration(seconds: 5));
      await fetchAliases();
    }
  }

  Future<void> _setOfflineState() async {
    if (state.status != AliasTabStatus.failed) {
      final savedAliases = await _loadOfflineData();
      if (savedAliases.isNotEmpty) {
        final availableAliasList = <Alias>[];
        final deletedAliasList = <Alias>[];
        final forwardedList = <int>[];
        final blockedList = <int>[];
        final repliedList = <int>[];
        final sentList = <int>[];

        for (Alias alias in savedAliases) {
          forwardedList.add(alias.emailsForwarded);
          blockedList.add(alias.emailsBlocked);
          repliedList.add(alias.emailsReplied);
          sentList.add(alias.emailsSent);

          if (alias.deletedAt == null) {
            availableAliasList.add(alias);
          } else {
            deletedAliasList.add(alias);
          }
        }

        state = state.copyWith(
          status: AliasTabStatus.loaded,
          aliases: savedAliases,
          availableAliasList: availableAliasList,
          deletedAliasList: deletedAliasList,
          forwardedList: _reduceList(forwardedList),
          blockedList: _reduceList(blockedList),
          repliedList: _reduceList(repliedList),
          sentList: _reduceList(sentList),
        );
      }
    }
  }

  Future<List<Alias>> _loadOfflineData() async {
    List<dynamic> decodedData = [];
    final securedData = await offlineData.readAliasOfflineData();
    if (securedData.isNotEmpty) decodedData = jsonDecode(securedData);

    if (decodedData.isNotEmpty) {
      final aliases = decodedData.map((alias) {
        return Alias.fromJson(alias);
      }).toList();
      return aliases;
    } else {
      return [];
    }
  }

  Future<void> _saveOfflineData(List<Alias> aliases) async {
    final encodedData = jsonEncode(aliases);
    await offlineData.writeAliasOfflineData(encodedData);
  }

  void addAlias(Alias alias) {
    /// Put new alias in the first spot
    state.aliases!.insert(0, alias);
    state = state.copyWith(aliases: state.aliases);
  }

  void deleteAlias(String aliasId) {
    /// Remove alias from aliases list
    state.aliases!.removeWhere((alias) => alias.id == aliasId);
    state = state.copyWith(aliases: state.aliases);
  }

  int _reduceList(List<int> list) {
    if (list.isEmpty) {
      return 0;
    } else {
      return list.reduce((value, element) => value + element);
    }
  }
}
