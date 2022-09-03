import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/domain/domains_service.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/notifiers/domains/domains_screen_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainsScreenStateNotifier = StateNotifierProvider.autoDispose<
    DomainsScreenNotifier, DomainsScreenState>((ref) {
  return DomainsScreenNotifier(
    domainService: ref.read(domainService),
  );
});

class DomainsScreenNotifier extends StateNotifier<DomainsScreenState> {
  DomainsScreenNotifier({required this.domainService})
      : super(DomainsScreenState.initialState());

  final DomainsService domainService;

  /// Updates DomainScreen state
  void _updateState(DomainsScreenState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchDomain(Domain domain) async {
    try {
      _updateState(state.copyWith(status: DomainsScreenStatus.loading));
      final updatedDomain = await domainService.getSpecificDomain(domain.id);

      _updateState(state.copyWith(
        status: DomainsScreenStatus.loaded,
        domain: updatedDomain,
      ));
    } on DioError catch (dioError) {
      /// Return old domain data if there's no internet connection
      if (dioError.type == DioErrorType.other) {
        _updateState(state.copyWith(
          status: DomainsScreenStatus.loaded,
          domain: domain,
        ));
      } else {
        _updateState(state.copyWith(
          status: DomainsScreenStatus.failed,
          errorMessage: dioError.message,
        ));
      }
    } catch (error) {
      _updateState(state.copyWith(
        status: DomainsScreenStatus.failed,
        errorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }

  Future editDescription(String domainId, newDescription) async {
    try {
      final updatedDomain =
          await domainService.updateDomainDescription(domainId, newDescription);
      NicheMethod.showToast(ToastMessage.editDescriptionSuccess);
      _updateState(state.copyWith(domain: updatedDomain));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }

  Future<void> activateDomain(String domainId) async {
    try {
      _updateState(state.copyWith(activeSwitchLoading: true));
      final newDomain = await domainService.activateDomain(domainId);
      final updatedDomain = state.domain.copyWith(active: newDomain.active);

      _updateState(state.copyWith(
        activeSwitchLoading: false,
        domain: updatedDomain,
      ));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
      _updateState(state.copyWith(activeSwitchLoading: false));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(activeSwitchLoading: false));
    }
  }

  Future<void> deactivateDomain(String domainId) async {
    _updateState(state.copyWith(activeSwitchLoading: true));
    try {
      await domainService.deactivateDomain(domainId);

      final updatedDomain = state.domain.copyWith(active: false);

      _updateState(state.copyWith(
        activeSwitchLoading: false,
        domain: updatedDomain,
      ));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
      _updateState(state.copyWith(activeSwitchLoading: false));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(activeSwitchLoading: false));
    }
  }

  Future<void> activateCatchAll(String domainId) async {
    _updateState(state.copyWith(catchAllSwitchLoading: true));
    try {
      final newDomain = await domainService.activateCatchAll(domainId);

      final updatedDomain = state.domain.copyWith(catchAll: newDomain.catchAll);

      _updateState(state.copyWith(
        catchAllSwitchLoading: false,
        domain: updatedDomain,
      ));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    }
  }

  Future<void> deactivateCatchAll(String domainId) async {
    _updateState(state.copyWith(catchAllSwitchLoading: true));
    try {
      await domainService.deactivateCatchAll(domainId);

      final updatedDomain = state.domain.copyWith(catchAll: false);

      _updateState(state.copyWith(
        catchAllSwitchLoading: false,
        domain: updatedDomain,
      ));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    }
  }

  Future<void> updateDomainDefaultRecipients(
      String domainId, String recipientId) async {
    try {
      _updateState(state.copyWith(updateRecipientLoading: true));
      final newDomain = await domainService.updateDomainDefaultRecipient(
          domainId, recipientId);

      NicheMethod.showToast('Default recipient updated successfully!');

      final updatedDomain =
          state.domain.copyWith(defaultRecipient: newDomain.defaultRecipient);

      _updateState(state.copyWith(
        updateRecipientLoading: false,
        domain: updatedDomain,
      ));
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
      _updateState(state.copyWith(updateRecipientLoading: false));
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
      _updateState(state.copyWith(updateRecipientLoading: false));
    }
  }

  Future<void> deleteDomain(String domainId) async {
    try {
      await domainService.deleteDomain(domainId);
      NicheMethod.showToast('Domain deleted successfully!');
    } on DioError catch (dioError) {
      NicheMethod.showToast(dioError.message);
    } catch (error) {
      NicheMethod.showToast(AppStrings.somethingWentWrong);
    }
  }
}
