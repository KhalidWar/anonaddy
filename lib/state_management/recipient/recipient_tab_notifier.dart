import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_state.dart';
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
  }) : super(const RecipientTabState(status: RecipientTabStatus.loading)) {
    _loadOfflineData();
  }

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
    } on SocketException {
      await _loadOfflineData();
    } catch (error) {
      final dioError = error as DioError;
      final newState = state.copyWith(
        status: RecipientTabStatus.failed,
        errorMessage: dioError.message,
      );
      _updateState(newState);
      await _retryOnError();
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
    if (state.status == RecipientTabStatus.failed) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchRecipients();
    }
  }

  Future<void> _loadOfflineData() async {
    final securedData = await offlineData.readRecipientsOfflineData();
    if (securedData.isNotEmpty) {
      final decodedData = jsonDecode(securedData);
      final recipients = (decodedData as List).map((alias) {
        return Recipient.fromJson(alias);
      }).toList();

      final newState = state.copyWith(
          status: RecipientTabStatus.loaded, recipients: recipients);
      _updateState(newState);
    }
  }

  Future<void> _saveOfflineData(List<Recipient> recipient) async {
    final encodedData = jsonEncode(recipient);
    await offlineData.writeRecipientsOfflineData(encodedData);
  }
}
