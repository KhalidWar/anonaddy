import 'dart:async';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/toast_message.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/aliases/data/alias_screen_service.dart';
import 'package:anonaddy/features/aliases/presentation/controller/alias_screen_state.dart';
import 'package:anonaddy/features/aliases/presentation/controller/available_aliases_notifier.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
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
          .read(aliasScreenServiceProvider)
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
          .read(aliasScreenServiceProvider)
          .deactivateAlias(currentState.alias.id);

      final alias =
          await ref.read(aliasScreenServiceProvider).fetchSpecificAlias(arg);
      state = AsyncData(state.value!.copyWith(
        isToggleLoading: false,
        alias: alias,
      ));
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
          .read(aliasScreenServiceProvider)
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

      await ref
          .read(aliasScreenServiceProvider)
          .deleteAlias(currentState.alias.id);
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
          .read(aliasScreenServiceProvider)
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
      await ref
          .read(aliasScreenServiceProvider)
          .forgetAlias(state.value!.alias.id);
      Utilities.showToast(ToastMessage.forgetAliasSuccess);
      await ref.read(aliasesNotifierProvider.notifier).fetchAliases();
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> sendFromAlias(String destinationEmail) async {
    try {
      final generatedAddress = ref
          .read(aliasScreenServiceProvider)
          .generateSendFromAlias(state.value!.alias.email, destinationEmail);
      await Utilities.copyOnTap(generatedAddress);
      Utilities.showToast(ToastMessage.sendFromAliasSuccess);
    } catch (error) {
      Utilities.showToast(AppStrings.somethingWentWrong);
    }
  }

  @override
  FutureOr<AliasScreenState> build(String arg) async {
    final aliasService = ref.read(aliasScreenServiceProvider);

    final alias = await aliasService.fetchSpecificAlias(arg);

    return AliasScreenState(
      alias: alias,
      isToggleLoading: false,
      deleteAliasLoading: false,
      updateRecipientLoading: false,
    );
  }
}
