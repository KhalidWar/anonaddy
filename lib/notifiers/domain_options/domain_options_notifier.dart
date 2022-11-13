import 'package:anonaddy/notifiers/domain_options/domain_options_state.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainOptionsStateNotifier =
    StateNotifierProvider<DomainOptionsNotifier, DomainOptionsState>((ref) {
  return DomainOptionsNotifier(
    domainOptionsService: ref.read(domainOptionsService),
  );
});

class DomainOptionsNotifier extends StateNotifier<DomainOptionsState> {
  DomainOptionsNotifier({required this.domainOptionsService})
      : super(const DomainOptionsState(status: DomainOptionsStatus.loading));

  final DomainOptionsService domainOptionsService;

  /// Updates UI to the latest state
  void _updateState(DomainOptionsState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchDomainOption() async {
    try {
      final domainOptions = await domainOptionsService.fetchDomainOptions();

      final newState = DomainOptionsState(
          status: DomainOptionsStatus.loaded, domainOptions: domainOptions);
      _updateState(newState);
    } catch (error) {
      _updateState(DomainOptionsState(
        status: DomainOptionsStatus.failed,
        errorMessage: error.toString(),
      ));

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

  Future<void> loadDataFromDisk() async {
    try {
      final domainOptions = await domainOptionsService.loadDataFromDisk();
      _updateState(DomainOptionsState(
        status: DomainOptionsStatus.loaded,
        domainOptions: domainOptions,
      ));
    } catch (error) {
      return;
    }
  }
}
