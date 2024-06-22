import 'dart:async';

import 'package:anonaddy/common/constants/toast_message.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/domains/data/domain_screen_service.dart';
import 'package:anonaddy/features/domains/domain/domain.dart';
import 'package:anonaddy/features/domains/presentation/controller/domains_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainsScreenStateNotifier = AsyncNotifierProvider.family
    .autoDispose<DomainsScreenNotifier, DomainsScreenState, String>(
        DomainsScreenNotifier.new);

class DomainsScreenNotifier
    extends AutoDisposeFamilyAsyncNotifier<DomainsScreenState, String> {
  Future<void> fetchDomain(Domain domain) async {
    try {
      state = const AsyncLoading();
      final updatedDomain =
          await ref.read(domainScreenService).fetchSpecificDomain(domain.id);

      state = AsyncData(state.value!.copyWith(domain: updatedDomain));
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.empty);
    }
  }

  Future editDescription(String domainId, newDescription) async {
    try {
      final updatedDomain = await ref
          .read(domainScreenService)
          .updateDomainDescription(domainId, newDescription);
      Utilities.showToast(ToastMessage.editDescriptionSuccess);
      state = AsyncData(state.value!.copyWith(domain: updatedDomain));
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> activateDomain(String domainId) async {
    try {
      state = AsyncData(state.value!.copyWith(activeSwitchLoading: true));
      final newDomain =
          await ref.read(domainScreenService).activateDomain(domainId);
      final updatedDomain =
          state.value!.domain.copyWith(active: newDomain.active);

      state = AsyncData(state.value!.copyWith(
        activeSwitchLoading: false,
        domain: updatedDomain,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(activeSwitchLoading: false));
    }
  }

  Future<void> deactivateDomain(String domainId) async {
    state = AsyncData(state.value!.copyWith(activeSwitchLoading: true));
    try {
      await ref.read(domainScreenService).deactivateDomain(domainId);

      final updatedDomain = state.value!.domain.copyWith(active: false);

      state = AsyncData(state.value!.copyWith(
        activeSwitchLoading: false,
        domain: updatedDomain,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(activeSwitchLoading: false));
    }
  }

  Future<void> activateCatchAll(String domainId) async {
    state = AsyncData(state.value!.copyWith(catchAllSwitchLoading: true));

    try {
      final newDomain =
          await ref.read(domainScreenService).activateCatchAll(domainId);

      final updatedDomain =
          state.value!.domain.copyWith(catchAll: newDomain.catchAll);

      state = AsyncData(state.value!.copyWith(
        catchAllSwitchLoading: false,
        domain: updatedDomain,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(catchAllSwitchLoading: false));
    }
  }

  Future<void> deactivateCatchAll(String domainId) async {
    state = AsyncData(state.value!.copyWith(catchAllSwitchLoading: true));

    try {
      await ref.read(domainScreenService).deactivateCatchAll(domainId);

      final updatedDomain = state.value!.domain.copyWith(catchAll: false);

      state = AsyncData(state.value!.copyWith(
        catchAllSwitchLoading: false,
        domain: updatedDomain,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(catchAllSwitchLoading: false));
    }
  }

  Future<void> updateDomainDefaultRecipients(
      String domainId, String? recipientId) async {
    try {
      state = AsyncData(state.value!.copyWith(updateRecipientLoading: true));

      await ref
          .read(domainScreenService)
          .updateDomainDefaultRecipient(domainId, recipientId);

      Utilities.showToast('Default recipient updated successfully!');

      final domain =
          await ref.read(domainScreenService).fetchSpecificDomain(domainId);

      state = AsyncData(state.value!.copyWith(
        updateRecipientLoading: false,
        domain: domain,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(updateRecipientLoading: false));
    }
  }

  Future<void> deleteDomain(String domainId) async {
    try {
      await ref.read(domainScreenService).deleteDomain(domainId);
      Utilities.showToast('Domain deleted successfully!');
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  @override
  FutureOr<DomainsScreenState> build(String arg) async {
    final domainService = ref.read(domainScreenService);
    final domain = await domainService.fetchSpecificDomain(arg);

    return DomainsScreenState(
      domain: domain,
      activeSwitchLoading: false,
      catchAllSwitchLoading: false,
      updateRecipientLoading: false,
    );
  }
}
