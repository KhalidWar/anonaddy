import 'dart:io';

import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/domain/domains_service.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:anonaddy/state_management/domains/domains_screen_state.dart';
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
      : super(DomainsScreenState.initial());

  final DomainsService domainService;

  final showToast = NicheMethod.showToast;

  /// Updates DomainScreen state
  void _updateState(DomainsScreenState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchDomain(Domain domain) async {
    _updateState(state.copyWith(status: DomainsScreenStatus.loading));
    try {
      final updatedDomain = await domainService.getSpecificDomain(domain.id);
      final newState = state.copyWith(
          status: DomainsScreenStatus.loaded, domain: updatedDomain);
      _updateState(newState);
    } on SocketException {
      /// Return old domain data if there's no internet connection
      final newState =
          state.copyWith(status: DomainsScreenStatus.loaded, domain: domain);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      final newState = state.copyWith(
          status: DomainsScreenStatus.failed, errorMessage: dioError.message);
      _updateState(newState);
    }
  }

  Future editDescription(String domainId, newDescription) async {
    try {
      final updatedDomain =
          await domainService.updateDomainDescription(domainId, newDescription);
      showToast(ToastMessage.editDescriptionSuccess);
      _updateState(state.copyWith(domain: updatedDomain));
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
    }
  }

  Future<void> activateDomain(String domainId) async {
    _updateState(state.copyWith(activeSwitchLoading: true));
    try {
      final newDomain = await domainService.activateDomain(domainId);
      final oldDomain = state.domain!;
      oldDomain.active = newDomain.active;
      final newState =
          state.copyWith(activeSwitchLoading: false, domain: oldDomain);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
      _updateState(state.copyWith(activeSwitchLoading: false));
    }
  }

  Future<void> deactivateDomain(String domainId) async {
    _updateState(state.copyWith(activeSwitchLoading: true));
    try {
      await domainService.deactivateDomain(domainId);
      final oldDomain = state.domain!;
      oldDomain.active = false;
      final newState =
          state.copyWith(activeSwitchLoading: false, domain: oldDomain);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
      _updateState(state.copyWith(activeSwitchLoading: false));
    }
  }

  Future<void> activateCatchAll(String domainId) async {
    _updateState(state.copyWith(catchAllSwitchLoading: true));
    try {
      final newDomain = await domainService.activateCatchAll(domainId);
      final oldDomain = state.domain!;
      oldDomain.catchAll = newDomain.catchAll;
      final newState =
          state.copyWith(catchAllSwitchLoading: false, domain: oldDomain);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    }
  }

  Future<void> deactivateCatchAll(String domainId) async {
    _updateState(state.copyWith(catchAllSwitchLoading: true));
    try {
      await domainService.deactivateCatchAll(domainId);
      final oldDomain = state.domain!;
      oldDomain.catchAll = false;
      final newState =
          state.copyWith(catchAllSwitchLoading: false, domain: oldDomain);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
      _updateState(state.copyWith(catchAllSwitchLoading: false));
    }
  }

  Future<void> updateDomainDefaultRecipients(
      String domainId, String recipientId) async {
    _updateState(state.copyWith(updateRecipientLoading: true));
    try {
      final updatedDomain = await domainService.updateDomainDefaultRecipient(
          domainId, recipientId);
      state.domain!.defaultRecipient = updatedDomain.defaultRecipient;
      showToast('Default recipient updated successfully!');
      final newState =
          state.copyWith(updateRecipientLoading: false, domain: state.domain);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
      _updateState(state.copyWith(updateRecipientLoading: false));
    }
  }

  Future<void> deleteDomain(String domainId) async {
    try {
      await domainService.deleteDomain(domainId);
      showToast('Domain deleted successfully!');
    } catch (error) {
      final dioError = error as DioError;
      showToast(dioError.message);
    }
  }
}
