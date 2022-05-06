import 'dart:convert';

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
    } catch (error) {
      final dioError = error as DioError;

      /// If offline, load offline data.
      if (dioError.type == DioErrorType.other) {
        await loadOfflineState();
      } else {
        final newState = state.copyWith(
            status: DomainsTabStatus.failed, errorMessage: dioError.message);
        _updateState(newState);
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

  /// Fetches recipients from disk and displays them, used at initial app
  /// startup since fetching from disk is a lot faster than fetching from API.
  /// It's also used to when there's no internet connection.
  Future<void> loadOfflineState() async {
    /// Only load offline data when state is NOT failed.
    /// Otherwise, it would always show offline data even if there's error.
    if (state.status != DomainsTabStatus.failed) {
      List<dynamic> decodedData = [];
      final securedData = await offlineData.readDomainOfflineData();
      if (securedData.isNotEmpty) decodedData = jsonDecode(securedData);
      final domains =
          decodedData.map((domain) => Domain.fromJson(domain)).toList();

      if (domains.isNotEmpty) {
        final newState = state.copyWith(
          status: DomainsTabStatus.loaded,
          domains: domains,
        );
        _updateState(newState);
      }
    }
  }

  Future<void> _saveOfflineData(List<Domain> domain) async {
    final encodedData = jsonEncode(domain);
    await offlineData.writeDomainOfflineData(encodedData);
  }
}
