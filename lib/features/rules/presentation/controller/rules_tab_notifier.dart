import 'package:anonaddy/features/rules/data/rules_service.dart';
import 'package:anonaddy/features/rules/domain/rules.dart';
import 'package:anonaddy/features/rules/presentation/controller/rules_tab_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rulesTabStateNotifier =
    StateNotifierProvider.autoDispose<RulesTabNotifier, RulesTabState>((ref) {
  return RulesTabNotifier(rulesService: ref.read(rulesService));
});

class RulesTabNotifier extends StateNotifier<RulesTabState> {
  RulesTabNotifier({required this.rulesService})
      : super(RulesTabState.initialState());

  final RulesService rulesService;

  /// Updates UI state
  void _updateState(RulesTabState newState) {
    /// Make sure Widget exists and NOT disposed of.
    if (mounted) state = newState;
  }

  /// Fetch all [Rules]s associated with user's account
  Future<void> fetchRules() async {
    try {
      final rules = await rulesService.fetchAllRules();

      /// Construct new UI state
      final newState =
          state.copyWith(status: RulesTabStatus.loaded, rules: rules);
      _updateState(newState);
    } catch (error) {
      _updateState(state.copyWith(
        status: RulesTabStatus.failed,
        errorMessage: error.toString(),
      ));
      await _retryOnError();
    }
  }

  Future _retryOnError() async {
    if (state.status.isFailed()) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchRules();
    }
  }

  Future<void> loadOfflineState() async {
    try {
      final rules = await rulesService.loadRulesFromDisk();
      _updateState(state.copyWith(
        status: RulesTabStatus.loaded,
        rules: rules,
      ));
    } catch (error) {
      return;
    }
  }
}
