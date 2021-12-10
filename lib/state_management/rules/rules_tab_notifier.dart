import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/services/rules/rules_service.dart';
import 'package:anonaddy/state_management/rules/rules_tab_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rulesTabStateNotifier =
    StateNotifierProvider.autoDispose<RulesTabNotifier, RulesTabState>((ref) {
  return RulesTabNotifier(
    rulesService: ref.read(rulesService),
  );
});

class RulesTabNotifier extends StateNotifier<RulesTabState> {
  RulesTabNotifier({required this.rulesService})
      : super(RulesTabState.initialState()) {
    fetchRules();
  }

  final RulesService rulesService;

  /// Updates UI state
  void _updateState(RulesTabState newState) {
    /// Make sure Widget exists and NOT disposed of.
    if (mounted) state = newState;
  }

  /// Fetch all [Rule]s associated with user's account
  Future<void> fetchRules() async {
    try {
      final rules = await rulesService.getAllRules();

      /// Construct new UI state
      final newState =
          RulesTabState(status: RulesTabStatus.loaded, rules: rules);
      _updateState(newState);
    } catch (error) {
      final newState = RulesTabState(
          status: RulesTabStatus.failed, errorMessage: error.toString());
      _updateState(newState);
    }
  }
}
