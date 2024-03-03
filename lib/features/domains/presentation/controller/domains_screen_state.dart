import 'package:anonaddy/features/domains/domain/domain.dart';

class DomainsScreenState {
  const DomainsScreenState({
    required this.domain,
    required this.activeSwitchLoading,
    required this.catchAllSwitchLoading,
    required this.updateRecipientLoading,
  });

  final Domain domain;
  final bool activeSwitchLoading;
  final bool catchAllSwitchLoading;
  final bool updateRecipientLoading;

  DomainsScreenState copyWith({
    Domain? domain,
    bool? activeSwitchLoading,
    bool? catchAllSwitchLoading,
    bool? updateRecipientLoading,
  }) {
    return DomainsScreenState(
      domain: domain ?? this.domain,
      activeSwitchLoading: activeSwitchLoading ?? this.activeSwitchLoading,
      catchAllSwitchLoading:
          catchAllSwitchLoading ?? this.catchAllSwitchLoading,
      updateRecipientLoading:
          updateRecipientLoading ?? this.updateRecipientLoading,
    );
  }

  @override
  String toString() {
    return 'DomainsScreenState{domain: $domain, activeSwitchLoading: $activeSwitchLoading, catchAllSwitchLoading: $catchAllSwitchLoading, updateRecipientLoading: $updateRecipientLoading}';
  }
}
