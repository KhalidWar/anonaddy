import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/domain/domains_service.dart';
import 'package:anonaddy/state_management/domains/domains_tab_state.dart';
import 'package:dio/dio.dart';
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
  }) : super(DomainsTabState.initialState());

  final DomainsService domainsService;
  final OfflineData offlineData;

  /// Updates DomainTab state
  void _updateState(DomainsTabState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchDomains() async {
    try {
      final domains = await domainsService.getDomains();
      await _saveOfflineData(domains);
      final newState =
          state.copyWith(status: DomainsTabStatus.loaded, domains: domains);
      _updateState(newState);
    } on SocketException {
      loadOfflineState();
    } catch (error) {
      final dioError = error as DioError;
      final newState = state.copyWith(
          status: DomainsTabStatus.failed, errorMessage: dioError.message);
      _updateState(newState);
      await _retryOnError();
    }
  }

  Future _retryOnError() async {
    if (state.status == DomainsTabStatus.failed) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchDomains();
    }
  }

  Future<void> loadOfflineState() async {
    if (state.status != DomainsTabStatus.failed) {
      final savedDomains = await _loadOfflineDomains();
      if (savedDomains.isNotEmpty) {
        final newState = state.copyWith(
          status: DomainsTabStatus.loaded,
          domains: savedDomains,
        );
        _updateState(newState);
      }
    }
  }

  Future<List<Domain>> _loadOfflineDomains() async {
    List<dynamic> decodedData = [];
    final securedData = await offlineData.readDomainOfflineData();
    if (securedData.isNotEmpty) decodedData = jsonDecode(securedData);

    return decodedData.map((alias) {
      return Domain.fromJson(alias);
    }).toList();
  }

  Future<void> _saveOfflineData(List<Domain> domain) async {
    final encodedData = jsonEncode(domain);
    await offlineData.writeDomainOfflineData(encodedData);
  }
}
