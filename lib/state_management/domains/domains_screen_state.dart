import 'package:anonaddy/models/domain/domain_model.dart';

enum DomainsScreenStatus { loading, loaded, failed }

class DomainsScreenState {
  const DomainsScreenState({
    this.status,
    this.domain,
    this.errorMessage,
    this.activeSwitchLoading,
    this.catchAllSwitchLoading,
    this.updateRecipientLoading,
  });

  final DomainsScreenStatus? status;
  final Domain? domain;
  final String? errorMessage;

  final bool? activeSwitchLoading;
  final bool? catchAllSwitchLoading;
  final bool? updateRecipientLoading;

  static DomainsScreenState initial() {
    return const DomainsScreenState(
      status: DomainsScreenStatus.loading,
      activeSwitchLoading: false,
      catchAllSwitchLoading: false,
      updateRecipientLoading: false,
    );
  }

  DomainsScreenState copyWith({
    DomainsScreenStatus? status,
    Domain? domain,
    String? errorMessage,
    bool? activeSwitchLoading,
    bool? catchAllSwitchLoading,
    bool? updateRecipientLoading,
  }) {
    return DomainsScreenState(
      status: status ?? this.status,
      domain: domain ?? this.domain,
      errorMessage: errorMessage ?? this.errorMessage,
      activeSwitchLoading: activeSwitchLoading ?? this.activeSwitchLoading,
      catchAllSwitchLoading:
          catchAllSwitchLoading ?? this.catchAllSwitchLoading,
      updateRecipientLoading:
          updateRecipientLoading ?? this.updateRecipientLoading,
    );
  }

  @override
  String toString() {
    return 'DomainsScreenState{status: $status, domain: $domain, errorMessage: $errorMessage, activeSwitchLoading: $activeSwitchLoading, catchAllSwitchLoading: $catchAllSwitchLoading, updateRecipientLoading: $updateRecipientLoading}';
  }
}
