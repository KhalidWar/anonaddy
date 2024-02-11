import 'package:anonaddy/features/domains/domain/domain_model.dart';

enum DomainsTabStatus { loading, loaded, failed }

class DomainsTabState {
  const DomainsTabState({
    required this.status,
    required this.domains,
    required this.errorMessage,
  });

  final DomainsTabStatus status;
  final List<Domain> domains;
  final String errorMessage;

  static DomainsTabState initialState() {
    return const DomainsTabState(
      status: DomainsTabStatus.loading,
      domains: <Domain>[],
      errorMessage: '',
    );
  }

  DomainsTabState copyWith({
    DomainsTabStatus? status,
    List<Domain>? domains,
    String? errorMessage,
  }) {
    return DomainsTabState(
      status: status ?? this.status,
      domains: domains ?? this.domains,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'DomainsTabState{status: $status, domains: $domains, errorMessage: $errorMessage}';
  }
}
