import 'dart:async';

import 'package:anonaddy/features/domains/data/domains_service.dart';
import 'package:anonaddy/features/domains/domain/domain.dart';
import 'package:anonaddy/features/domains/presentation/controller/domains_screen_state.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/utilities/utilities.dart';
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
          await ref.read(domainService).fetchSpecificDomain(domain.id);

      state = AsyncData(state.value!.copyWith(domain: updatedDomain));
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.empty);
    }
  }

  Future editDescription(String domainId, newDescription) async {
    try {
      final updatedDomain = await ref
          .read(domainService)
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
      final newDomain = await ref.read(domainService).activateDomain(domainId);
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
      await ref.read(domainService).deactivateDomain(domainId);

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
          await ref.read(domainService).activateCatchAll(domainId);

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
      await ref.read(domainService).deactivateCatchAll(domainId);

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
      String domainId, String recipientId) async {
    try {
      state = AsyncData(state.value!.copyWith(updateRecipientLoading: true));

      final newDomain = await ref
          .read(domainService)
          .updateDomainDefaultRecipient(domainId, recipientId);

      Utilities.showToast('Default recipient updated successfully!');

      final updatedDomain = state.value!.domain
          .copyWith(defaultRecipient: newDomain.defaultRecipient);

      state = AsyncData(state.value!.copyWith(
        updateRecipientLoading: false,
        domain: updatedDomain,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(updateRecipientLoading: false));
    }
  }

  Future<void> deleteDomain(String domainId) async {
    try {
      await ref.read(domainService).deleteDomain(domainId);
      Utilities.showToast('Domain deleted successfully!');
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  @override
  FutureOr<DomainsScreenState> build(String arg) async {
    final aliasService = ref.read(domainService);

    final domain = await aliasService.fetchSpecificDomain(arg);

    return DomainsScreenState(
      domain: domain,
      activeSwitchLoading: false,
      catchAllSwitchLoading: false,
      updateRecipientLoading: false,
    );
  }
}
