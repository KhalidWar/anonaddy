import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/domain/domains_service.dart';
import 'package:anonaddy/state_management/domains/domains_state.dart';
import 'package:anonaddy/state_management/lifecycle/lifecycle_state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

final domainsStateNotifier =
    StateNotifierProvider.autoDispose<DomainsNotifier, DomainsState>((ref) {
  return DomainsNotifier(
    domainsService: ref.read(domainService),
    offlineData: ref.read(offlineDataProvider),
    lifecycleStatus: ref.watch(lifecycleStateNotifier),
  );
});

class DomainsNotifier extends StateNotifier<DomainsState> {
  DomainsNotifier({
    required this.domainsService,
    required this.offlineData,
    required this.lifecycleStatus,
  }) : super(DomainsState(status: DomainsStatus.loading)) {
    fetchDomains();
  }

  final DomainsService domainsService;
  final OfflineData offlineData;
  final LifecycleStatus lifecycleStatus;

  Future<void> fetchDomains() async {
    try {
      final domains = await domainsService.getAllDomains();
      await _saveOfflineData(domains);
      state = DomainsState(
        status: DomainsStatus.loaded,
        domainModel: domains,
      );
    } on SocketException {
      await _loadOfflineData();
    } catch (error) {
      if (mounted) {
        state = DomainsState(
          status: DomainsStatus.failed,
          errorMessage: error.toString(),
        );
        await _retryOnError();
      }
    }
  }

  Future _retryOnError() async {
    if (state.status == DomainsStatus.failed) {
      await Future.delayed(Duration(seconds: 5));
      await fetchDomains();
    }
  }

  Future<void> _loadOfflineData() async {
    final securedData = await offlineData.readDomainOfflineData();
    if (securedData.isNotEmpty) {
      final data = DomainModel.fromJson(jsonDecode(securedData));
      state = DomainsState(status: DomainsStatus.loaded, domainModel: data);
    }
  }

  Future<void> _saveOfflineData(DomainModel domain) async {
    final encodedData = jsonEncode(domain.toJson());
    await offlineData.writeDomainOfflineData(encodedData);
  }
}
