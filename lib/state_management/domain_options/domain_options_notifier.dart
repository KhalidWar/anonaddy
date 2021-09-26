import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_state.dart';
import 'package:anonaddy/state_management/lifecycle/lifecycle_state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainOptionsStateNotifier =
    StateNotifierProvider<DomainOptionsNotifier, DomainOptionsState>((ref) {
  return DomainOptionsNotifier(
    domainOptionsService: ref.read(domainOptionsService),
    offlineData: ref.read(offlineDataProvider),
    lifecycleStatus: ref.watch(lifecycleStateNotifier),
  );
});

class DomainOptionsNotifier extends StateNotifier<DomainOptionsState> {
  DomainOptionsNotifier({
    required this.domainOptionsService,
    required this.offlineData,
    required this.lifecycleStatus,
  }) : super(DomainOptionsState(status: DomainOptionsStatus.loading)) {
    fetchDomainOption();
  }

  final DomainOptionsService domainOptionsService;
  final OfflineData offlineData;
  final LifecycleStatus lifecycleStatus;

  Future fetchDomainOption() async {
    try {
      if (state.status != DomainOptionsStatus.failed) {
        await _loadOfflineData();
      }

      while (lifecycleStatus == LifecycleStatus.foreground) {
        final domainOptions = await domainOptionsService.getDomainOptions();
        await _saveOfflineData(domainOptions);
        state = DomainOptionsState(
            status: DomainOptionsStatus.loaded, domainOptions: domainOptions);
        await Future.delayed(Duration(seconds: 1));
      }
    } on SocketException {
      await _loadOfflineData();
    } catch (error) {
      if (mounted) {
        state = DomainOptionsState(
          status: DomainOptionsStatus.failed,
          errorMessage: error.toString(),
        );
        await _retryOnError();
      }
    }
  }

  Future _retryOnError() async {
    if (state.status == DomainOptionsStatus.failed) {
      await Future.delayed(Duration(seconds: 5));
      await fetchDomainOption();
    }
  }

  Future<void> _loadOfflineData() async {
    final securedData = await offlineData.readDomainOptionsOfflineData();
    if (securedData.isNotEmpty) {
      final data = DomainOptions.fromJson(jsonDecode(securedData));
      state = DomainOptionsState(
          status: DomainOptionsStatus.loaded, domainOptions: data);
    }
  }

  Future<void> _saveOfflineData(DomainOptions domainOptions) async {
    final encodedData = jsonEncode(domainOptions.toJson());
    await offlineData.writeDomainOptionsOfflineData(encodedData);
  }
}
