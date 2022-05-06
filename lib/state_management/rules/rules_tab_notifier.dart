import 'dart:convert';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/rules/rules.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/rules/rules_service.dart';
import 'package:anonaddy/state_management/rules/rules_tab_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rulesTabStateNotifier =
    StateNotifierProvider.autoDispose<RulesTabNotifier, RulesTabState>((ref) {
  return RulesTabNotifier(
    rulesService: ref.read(rulesService),
    offlineData: ref.read(offlineDataProvider),
  );
});

class RulesTabNotifier extends StateNotifier<RulesTabState> {
  RulesTabNotifier({
    required this.rulesService,
    required this.offlineData,
  }) : super(RulesTabState.initialState());

  final RulesService rulesService;
  final OfflineData offlineData;

  /// Updates UI state
  void _updateState(RulesTabState newState) {
    /// Make sure Widget exists and NOT disposed of.
    if (mounted) state = newState;
  }

  /// Fetch all [Rule]s associated with user's account
  Future<void> fetchRules() async {
    try {
      final rules = await rulesService.getAllRules();
      await _saveOfflineData(rules);

      /// Construct new UI state
      final newState =
          state.copyWith(status: RulesTabStatus.loaded, rules: rules);
      _updateState(newState);
    } catch (error) {
      if (error == DioError) {
        final dioError = error as DioError;

        /// If offline, load offline data.
        if (dioError.type == DioErrorType.other) {
          await loadOfflineState();
        } else {
          final newState = state.copyWith(
            status: RulesTabStatus.failed,
            errorMessage: dioError.message,
          );
          _updateState(newState);
          await _retryOnError();
        }
      }
    }
  }

  Future _retryOnError() async {
    if (state.status.isFailed()) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchRules();
    }
  }

  /// Fetches recipients from disk and displays them, used at initial app
  /// startup since fetching from disk is a lot faster than fetching from API.
  /// It's also used to when there's no internet connection.
  Future<void> loadOfflineState() async {
    /// Only load offline data when state is NOT failed.
    /// Otherwise, it would always show offline data even if there's error.
    if (!state.status.isFailed()) {
      List<dynamic> decodedData = [];
      final securedData = await offlineData.readRulesOfflineData();
      if (securedData.isNotEmpty) decodedData = jsonDecode(securedData);
      final rules = decodedData.map((rule) => Rules.fromJson(rule)).toList();

      if (rules.isNotEmpty) {
        final newState = state.copyWith(
          status: RulesTabStatus.loaded,
          rules: rules,
        );
        _updateState(newState);
      }
    }
  }

  Future<void> _saveOfflineData(List<Rules> rules) async {
    final encodedData = jsonEncode(rules);
    await offlineData.writeRulesOfflineData(encodedData);
  }
}
