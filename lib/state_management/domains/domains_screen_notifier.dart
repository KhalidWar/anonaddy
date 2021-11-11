import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/services/domain/domains_service.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/state_management/domains/domains_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainsScreenStateNotifier = StateNotifierProvider.autoDispose<
    DomainsScreenNotifier, DomainsScreenState>((ref) {
  final services = ref.read(domainService);
  final toastMethod = ref.read(nicheMethods).showToast;
  return DomainsScreenNotifier(
    domainService: services,
    showToast: toastMethod,
  );
});

class DomainsScreenNotifier extends StateNotifier<DomainsScreenState> {
  DomainsScreenNotifier({required this.domainService, required this.showToast})
      : super(DomainsScreenState.initial());

  final DomainsService domainService;
  final Function showToast;

  Future<void> fetchDomain(String domainId) async {
    state = state.copyWith(status: DomainsScreenStatus.loading);
    try {
      final domain = await domainService.getSpecificDomain(domainId);
      state =
          state.copyWith(status: DomainsScreenStatus.loaded, domain: domain);
    } catch (error) {
      state = state.copyWith(
        status: DomainsScreenStatus.failed,
        errorMessage: error.toString(),
      );
    }
  }

  Future editDescription(String domainId, newDescription) async {
    try {
      final updatedDomain =
          await domainService.editDomainDescription(domainId, newDescription);
      showToast(kEditDescriptionSuccess);
      state = state.copyWith(domain: updatedDomain);
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> toggleOnActivity(String domainId) async {
    state = state.copyWith(activeSwitchLoading: true);
    try {
      final newDomain = await domainService.activateDomain(domainId);
      final oldDomain = state.domain!;
      oldDomain.active = newDomain.active;
      state = state.copyWith(activeSwitchLoading: false, domain: oldDomain);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(activeSwitchLoading: false);
    }
  }

  Future<void> toggleOffActivity(String domainId) async {
    state = state.copyWith(activeSwitchLoading: true);
    try {
      await domainService.deactivateDomain(domainId);
      final oldDomain = state.domain!;
      oldDomain.active = false;
      state = state.copyWith(activeSwitchLoading: false, domain: oldDomain);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(activeSwitchLoading: false);
    }
  }

  Future<void> toggleOnCatchAll(String domainId) async {
    state = state.copyWith(catchAllSwitchLoading: true);
    try {
      final newDomain = await domainService.activateCatchAll(domainId);
      final oldDomain = state.domain!;
      oldDomain.catchAll = newDomain.catchAll;
      state = state.copyWith(catchAllSwitchLoading: false, domain: oldDomain);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(catchAllSwitchLoading: false);
    }
  }

  Future<void> toggleOffCatchAll(String domainId) async {
    state = state.copyWith(catchAllSwitchLoading: true);
    try {
      await domainService.deactivateCatchAll(domainId);
      final oldDomain = state.domain!;
      oldDomain.catchAll = false;
      state = state.copyWith(catchAllSwitchLoading: false, domain: oldDomain);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(catchAllSwitchLoading: false);
    }
  }

  Future<void> updateDomainDefaultRecipients(
      String domainId, String recipientId) async {
    state = state.copyWith(updateRecipientLoading: true);
    try {
      final updatedDomain = await domainService.updateDomainDefaultRecipient(
          domainId, recipientId);
      state.domain!.defaultRecipient = updatedDomain.defaultRecipient;
      showToast('Default recipient updated successfully!');
      state =
          state.copyWith(updateRecipientLoading: false, domain: state.domain);
    } catch (error) {
      showToast(error.toString());
      state = state.copyWith(updateRecipientLoading: false);
    }
  }

  Future<void> deleteDomain(String domainId) async {
    try {
      await domainService.deleteDomain(domainId);
      showToast('Domain deleted successfully!');
    } catch (error) {
      showToast(error.toString());
    }
  }

  // Future<void> createNewDomain(BuildContext context, String domain) async {
  //   final createDomainFormKey = GlobalKey<FormState>();
  //   if (createDomainFormKey.currentState!.validate()) {
  //     await domainService.createNewDomain(domain).then((domain) {
  //       showToast('domain added successfully!');
  //       Navigator.pop(context);
  //     }).catchError((error) {
  //       showToast(error.toString());
  //     });
  //   }
  // }
}
