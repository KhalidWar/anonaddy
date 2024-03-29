import 'dart:async';

import 'package:anonaddy/features/aliases/data/alias_service.dart';
import 'package:anonaddy/features/aliases/presentation/controller/alias_screen_state.dart';
import 'package:anonaddy/features/aliases/presentation/controller/aliases_notifier.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aliasScreenNotifierProvider = AsyncNotifierProvider.family
    .autoDispose<AliasScreenNotifier, AliasScreenState, String>(
        AliasScreenNotifier.new);

class AliasScreenNotifier
    extends AutoDisposeFamilyAsyncNotifier<AliasScreenState, String> {
  Future<void> editDescription(String newDesc) async {
    try {
      final currentState = state.value!;
      final updatedAlias = await ref
          .read(aliasServiceProvider)
          .updateAliasDescription(currentState.alias.id, newDesc);
      Utilities.showToast(ToastMessage.editDescriptionSuccess);
      state = AsyncData(currentState.copyWith(alias: updatedAlias));
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> deactivateAlias() async {
    try {
      final currentState = state.value!;
      state = AsyncData(currentState.copyWith(isToggleLoading: true));

      await ref
          .read(aliasServiceProvider)
          .deactivateAlias(currentState.alias.id);
      ref.invalidate(aliasScreenNotifierProvider(arg));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(isToggleLoading: false));
    }
  }

  Future<void> activateAlias() async {
    try {
      final currentState = state.value!;
      state = AsyncData(currentState.copyWith(isToggleLoading: true));

      final updateAlias = await ref
          .read(aliasServiceProvider)
          .activateAlias(currentState.alias.id);

      state = AsyncData(currentState.copyWith(
        isToggleLoading: false,
        alias: updateAlias,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(isToggleLoading: false));
    }
  }

  Future<void> deleteAlias() async {
    try {
      final currentState = state.value!;
      state = AsyncData(currentState.copyWith(deleteAliasLoading: true));

      await ref.read(aliasServiceProvider).deleteAlias(currentState.alias.id);
      Utilities.showToast(ToastMessage.deleteAliasSuccess);

      await ref.read(aliasesNotifierProvider.notifier).fetchAliases();
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(deleteAliasLoading: false));
      rethrow;
    }
  }

  Future<void> restoreAlias() async {
    try {
      final currentState = state.value!;
      state = AsyncData(currentState.copyWith(deleteAliasLoading: true));

      final newAlias = await ref
          .read(aliasServiceProvider)
          .restoreAlias(currentState.alias.id);
      Utilities.showToast(ToastMessage.restoreAliasSuccess);

      state = AsyncData(currentState.copyWith(
        deleteAliasLoading: false,
        alias: newAlias,
      ));
      await ref.read(aliasesNotifierProvider.notifier).fetchAliases();
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(deleteAliasLoading: false));
    }
  }

  bool isRecipientDefault(Recipient recipient) {
    return state.value!.alias.recipients.contains(recipient);
  }

  Future<void> forgetAlias() async {
    try {
      await ref.read(aliasServiceProvider).forgetAlias(state.value!.alias.id);
      Utilities.showToast(ToastMessage.forgetAliasSuccess);
      await ref.read(aliasesNotifierProvider.notifier).fetchAliases();
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> sendFromAlias(String destinationEmail) async {
    try {
      final generatedAddress = ref
          .read(aliasServiceProvider)
          .generateSendFromAlias(state.value!.alias.email, destinationEmail);
      await Utilities.copyOnTap(generatedAddress);
      Utilities.showToast(ToastMessage.sendFromAliasSuccess);
    } catch (error) {
      Utilities.showToast(AppStrings.somethingWentWrong);
    }
  }

  @override
  FutureOr<AliasScreenState> build(String arg) async {
    final aliasService = ref.read(aliasServiceProvider);

    final alias = await aliasService.fetchSpecificAlias(arg);

    return AliasScreenState(
      alias: alias,
      isToggleLoading: false,
      deleteAliasLoading: false,
      updateRecipientLoading: false,
      isOffline: false,
    );
  }
}
