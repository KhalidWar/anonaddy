import 'dart:convert';

import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/notifiers/recipient/recipient_tab_state.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientTabStateNotifier =
    StateNotifierProvider<RecipientTabNotifier, RecipientTabState>((ref) {
  return RecipientTabNotifier(
    recipientService: ref.read(recipientService),
    offlineData: ref.read(offlineDataProvider),
  );
});

class RecipientTabNotifier extends StateNotifier<RecipientTabState> {
  RecipientTabNotifier({
    required this.recipientService,
    required this.offlineData,
  }) : super(RecipientTabState.initialState());

  final RecipientService recipientService;
  final OfflineData offlineData;

  void _updateState(RecipientTabState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchRecipients() async {
    _updateState(state.copyWith(status: RecipientTabStatus.loading));

    try {
      final recipients = await recipientService.getRecipients();
      await _saveOfflineData(recipients);
      final newState = state.copyWith(
          status: RecipientTabStatus.loaded, recipients: recipients);
      _updateState(newState);
    } catch (error) {
      if (error == DioError) {
        final dioError = error as DioError;

        /// If offline, load offline data.
        if (dioError.type == DioErrorType.other) {
          await loadOfflineState();
        } else {
          final newState = state.copyWith(
            status: RecipientTabStatus.failed,
            errorMessage: dioError.message,
          );
          _updateState(newState);
          await _retryOnError();
        }
      }
    }
  }

  /// Silently fetches the latest recipient data and displays them
  Future<void> refreshRecipients() async {
    try {
      final recipients = await recipientService.getRecipients();
      await _saveOfflineData(recipients);

      final newState = state.copyWith(
          status: RecipientTabStatus.loaded, recipients: recipients);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      NicheMethod.showToast(dioError.message);
    }
  }

  Future _retryOnError() async {
    if (state.status.isFailed()) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchRecipients();
    }
  }

  /// Fetches recipients from disk and displays them, used at initial app
  /// startup since fetching from disk is a lot faster than fetching from API.
  /// It's also used to when there's no internet connection.
  Future<void> loadOfflineState() async {
    /// Only load offline data when state is NOT failed.
    /// Otherwise, it would always show offline data even if there's error.
    if (!state.status.isFailed()) {
      List<dynamic> encodedRecipients = [];
      final securedData = await offlineData.readRecipientsOfflineData();
      if (securedData.isNotEmpty) encodedRecipients = jsonDecode(securedData);
      final recipients = encodedRecipients
          .map((recipient) => Recipient.fromJson(recipient))
          .toList();

      if (recipients.isNotEmpty) {
        final newState = state.copyWith(
          status: RecipientTabStatus.loaded,
          recipients: recipients,
        );
        _updateState(newState);
      }
    }
  }

  Future<void> _saveOfflineData(List<Recipient> recipient) async {
    final encodedData = jsonEncode(recipient);
    await offlineData.writeRecipientsOfflineData(encodedData);
  }
}
