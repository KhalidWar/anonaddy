import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/domain/domains_service.dart';
import 'package:anonaddy/state_management/domains/domains_tab_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainsStateNotifier =
    StateNotifierProvider.autoDispose<DomainsTabNotifier, DomainsTabState>(
        (ref) {
  return DomainsTabNotifier(
    domainsService: ref.read(domainService),
    offlineData: ref.read(offlineDataProvider),
  );
});

class DomainsTabNotifier extends StateNotifier<DomainsTabState> {
  DomainsTabNotifier({
    required this.domainsService,
    required this.offlineData,
  }) : super(const DomainsTabState(status: DomainsTabStatus.loading));

  final DomainsService domainsService;
  final OfflineData offlineData;

  Future<void> fetchDomains() async {
    try {
      final domains = await domainsService.getAllDomains();
      await _saveOfflineData(domains);
      state = DomainsTabState(
        status: DomainsTabStatus.loaded,
        domainModel: domains,
      );
    } on SocketException {
      await _loadOfflineData();
    } catch (error) {
      if (mounted) {
        state = DomainsTabState(
          status: DomainsTabStatus.failed,
          errorMessage: error.toString(),
        );
        await _retryOnError();
      }
    }
  }

  Future _retryOnError() async {
    if (state.status == DomainsTabStatus.failed) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchDomains();
    }
  }

  Future<void> _loadOfflineData() async {
    final securedData = await offlineData.readDomainOfflineData();
    if (securedData.isNotEmpty) {
      final data = DomainModel.fromJson(jsonDecode(securedData));
      state =
          DomainsTabState(status: DomainsTabStatus.loaded, domainModel: data);
    }
  }

  Future<void> _saveOfflineData(DomainModel domain) async {
    final encodedData = jsonEncode(domain.toJson());
    await offlineData.writeDomainOfflineData(encodedData);
  }
}
