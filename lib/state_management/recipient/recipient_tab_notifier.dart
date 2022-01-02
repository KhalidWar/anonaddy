import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientTabStateNotifier =
    StateNotifierProvider.autoDispose<RecipientTabNotifier, RecipientTabState>(
        (ref) {
  return RecipientTabNotifier(
    recipientService: ref.read(recipientService),
    offlineData: ref.read(offlineDataProvider),
  );
});

class RecipientTabNotifier extends StateNotifier<RecipientTabState> {
  RecipientTabNotifier({
    required this.recipientService,
    required this.offlineData,
  }) : super(RecipientTabState(status: RecipientTabStatus.loading)) {
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
      final recipients = await recipientService.getAllRecipient();
      await _saveOfflineData(recipients);
      final newState = state.copyWith(
          status: RecipientTabStatus.loaded, recipients: recipients);
      _updateState(newState);
    } on SocketException {
      await _loadOfflineData();
    } catch (error) {
      final newState = state.copyWith(
          status: RecipientTabStatus.failed, errorMessage: error.toString());
      _updateState(newState);
      await _retryOnError();
    }
  }

  Future _retryOnError() async {
    if (state.status == RecipientTabStatus.failed) {
      await Future.delayed(Duration(seconds: 5));
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
