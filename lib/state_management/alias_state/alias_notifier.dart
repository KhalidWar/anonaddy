import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/state_management/lifecycle/lifecycle_state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';
import 'alias_state.dart';

final aliasStateNotifier =
    StateNotifierProvider<AliasNotifier, AliasState>((ref) {
  return AliasNotifier(
    aliasService: ref.read(aliasService),
    offlineData: ref.read(offlineDataProvider),
    lifecycleStatus: ref.watch(lifecycleStateNotifier),
  );
});

class AliasNotifier extends StateNotifier<AliasState> {
  AliasNotifier({
    required this.aliasService,
    required this.offlineData,
    required this.lifecycleStatus,
  }) : super(AliasState(status: AliasStatus.loading)) {
    fetchAliases();
  }

  final AliasService aliasService;
  final OfflineData offlineData;
  final LifecycleStatus lifecycleStatus;
  // final bool refresh;

  Future<void> fetchAliases() async {
    try {
      if (state.status != AliasStatus.failed) {
        await _loadOfflineData();
      }

      while (lifecycleStatus == LifecycleStatus.foreground) {
        final aliases = await aliasService.getAllAliasesData();
        await _saveOfflineData(aliases);
        state = AliasState(status: AliasStatus.loaded, aliases: aliases);
        await Future.delayed(Duration(seconds: 1));
      }
    } on SocketException {
      await _loadOfflineData();
    } catch (error) {
      if (mounted) {
        state = AliasState(
          status: AliasStatus.failed,
          errorMessage: error.toString(),
        );
        await _retryOnError();
      }
    }
  }

  Future _retryOnError() async {
    if (state.status == AliasStatus.failed) {
      await Future.delayed(Duration(seconds: 5));
      await fetchAliases();
    }
  }

  Future<void> _loadOfflineData() async {
    final securedData = await offlineData.readAliasOfflineData();
    final decodedData = jsonDecode(securedData);

    if (decodedData.isNotEmpty) {
      final aliases = (decodedData as List).map((alias) {
        return Alias.fromJson(alias);
      }).toList();

      state = AliasState(status: AliasStatus.loaded, aliases: aliases);
    }
  }

  Future<void> _saveOfflineData(List<Alias> aliases) async {
    final encodedData = jsonEncode(aliases);
    await offlineData.writeAliasOfflineData(encodedData);
  }
}
