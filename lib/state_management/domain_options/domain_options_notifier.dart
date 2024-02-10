import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainOptionsStateNotifier =
    StateNotifierProvider<DomainOptionsNotifier, DomainOptionsState>((ref) {
  return DomainOptionsNotifier(
    domainOptionsService: ref.read(domainOptionsService),
    offlineData: ref.read(offlineDataProvider),
  );
});

class DomainOptionsNotifier extends StateNotifier<DomainOptionsState> {
  DomainOptionsNotifier({
    required this.domainOptionsService,
    required this.offlineData,
  }) : super(const DomainOptionsState(status: DomainOptionsStatus.loading)) {
    /// Initially load data from disk (secured device storage)
    _loadOfflineData();
  }

  final DomainOptionsService domainOptionsService;
  final OfflineData offlineData;

  /// Updates UI to the latest state
  void _updateState(DomainOptionsState newState) {
    if (mounted) state = newState;
  }

  Future fetchDomainOption() async {
    try {
      final domainOptions = await domainOptionsService.getDomainOptions();
      await _saveOfflineData(domainOptions);

      final newState = DomainOptionsState(
          status: DomainOptionsStatus.loaded, domainOptions: domainOptions);
      _updateState(newState);
    } on SocketException {
      /// Loads offline data when there's no internet connection
      await _loadOfflineData();
    } catch (error) {
      final dioError = error as DioError;
      final newState = DomainOptionsState(
        status: DomainOptionsStatus.failed,
        errorMessage: dioError.message,
      );
      _updateState(newState);

      /// Retry after facing an error
      await _retryOnError();
    }
  }

  Future _retryOnError() async {
    if (state.status == DomainOptionsStatus.failed) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchDomainOption();
    }
  }

  Future<void> _loadOfflineData() async {
    final securedData = await offlineData.readDomainOptionsOfflineData();
    if (securedData.isNotEmpty) {
      final data = DomainOptions.fromJson(jsonDecode(securedData));
      final newState = DomainOptionsState(
          status: DomainOptionsStatus.loaded, domainOptions: data);
      _updateState(newState);
    }
  }

  Future<void> _saveOfflineData(DomainOptions domainOptions) async {
    final encodedData = jsonEncode(domainOptions.toJson());
    await offlineData.writeDomainOptionsOfflineData(encodedData);
  }
}
