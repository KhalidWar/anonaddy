import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/state_management/lifecycle/lifecycle_state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';
import 'alias_state.dart';

final aliasStateNotifier =
    StateNotifierProvider.autoDispose<AliasNotifier, AliasState>((ref) {
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
  }) : super(AliasState(status: AliasTabStatus.loading)) {
    fetchAliases();
  }

  final AliasService aliasService;
  final OfflineData offlineData;
  final LifecycleStatus lifecycleStatus;
  // final bool refresh;

  Future<void> fetchAliases() async {
    try {
      if (state.status != AliasTabStatus.failed) {
        await _loadOfflineData();
      }

      while (lifecycleStatus == LifecycleStatus.foreground) {
        final alias = await aliasService.getAllAliasesData();
        await _saveOfflineData(alias);
        state = AliasState(status: AliasTabStatus.loaded, aliasModel: alias);
        await Future.delayed(Duration(seconds: 1));
      }
    } on SocketException {
      await _loadOfflineData();
    } catch (error) {
      if (mounted) {
        state = AliasState(
          status: AliasTabStatus.failed,
          errorMessage: error.toString(),
        );
      }
      await _retryOnError();
    }
  }

  Future _retryOnError() async {
    if (state.status == AliasTabStatus.failed) {
      await Future.delayed(Duration(seconds: 5));
      await fetchAliases();
    }
  }

  Future<void> _loadOfflineData() async {
    final securedData = await offlineData.readAliasOfflineData();
    if (securedData.isNotEmpty) {
      final data = AliasModel.fromJson(jsonDecode(securedData));
      state = AliasState(status: AliasTabStatus.loaded, aliasModel: data);
    }
  }

  Future<void> _saveOfflineData(AliasModel alias) async {
    final encodedData = jsonEncode(alias.toJson());
    await offlineData.writeAliasOfflineData(encodedData);
  }
}
