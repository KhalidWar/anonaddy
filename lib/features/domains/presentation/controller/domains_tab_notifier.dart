import 'package:anonaddy/features/domains/data/domains_service.dart';
import 'package:anonaddy/features/domains/presentation/controller/domains_tab_state.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainsStateNotifier =
    StateNotifierProvider.autoDispose<DomainsTabNotifier, DomainsTabState>(
        (ref) {
  return DomainsTabNotifier(domainsService: ref.read(domainService));
});

class DomainsTabNotifier extends StateNotifier<DomainsTabState> {
  DomainsTabNotifier({required this.domainsService})
      : super(DomainsTabState.initialState());

  final DomainsService domainsService;

  /// Updates DomainTab state
  void _updateState(DomainsTabState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchDomains() async {
    try {
      final domains = await domainsService.fetchDomains();
      _updateState(state.copyWith(
        status: DomainsTabStatus.loaded,
        domains: domains,
      ));
    } catch (error) {
      _updateState(state.copyWith(
        status: DomainsTabStatus.failed,
        errorMessage: AppStrings.somethingWentWrong,
      ));
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
    try {
      final domains = await domainsService.loadDomainsFromDisk();
      _updateState(
        state.copyWith(
          status: DomainsTabStatus.loaded,
          domains: domains,
        ),
      );
    } catch (error) {
      return;
    }
  }
}
