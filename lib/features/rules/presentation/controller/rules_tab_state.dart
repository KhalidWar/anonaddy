import 'package:anonaddy/features/rules/domain/rules.dart';

enum RulesTabStatus { loading, loaded, failed }

extension Shortcuts on RulesTabStatus {
  bool isFailed() => this == RulesTabStatus.failed;
}

class RulesTabState {
  const RulesTabState({
    required this.status,
    required this.rules,
    required this.errorMessage,
  });

  final RulesTabStatus status;
  final List<Rules> rules;
  final String errorMessage;

  static RulesTabState initialState() {
    return const RulesTabState(
      status: RulesTabStatus.loading,
      rules: [],
      errorMessage: 'Something went wrong',
    );
  }

  RulesTabState copyWith({
    RulesTabStatus? status,
    List<Rules>? rules,
    String? errorMessage,
  }) {
    return RulesTabState(
      status: status ?? this.status,
      rules: rules ?? this.rules,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
