import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/state_management/lifecycle/lifecycle_state_manager.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientTabStateNotifier =
    StateNotifierProvider<RecipientTabNotifier, RecipientTabState>((ref) {
  return RecipientTabNotifier(
    recipientService: ref.read(recipientService),
    offlineData: ref.read(offlineDataProvider),
    lifecycleStatus: ref.watch(lifecycleStateNotifier),
  );
});

class RecipientTabNotifier extends StateNotifier<RecipientTabState> {
  RecipientTabNotifier({
    required this.recipientService,
    required this.offlineData,
    required this.lifecycleStatus,
  }) : super(RecipientTabState(status: RecipientTabStatus.loading)) {
    fetchRecipients();
  }

  final RecipientService recipientService;
  final OfflineData offlineData;
  final LifecycleStatus lifecycleStatus;

  Future<void> fetchRecipients() async {
    try {
      if (state.status != RecipientTabStatus.failed) {
        await _loadOfflineData();
      }

      while (lifecycleStatus == LifecycleStatus.foreground) {
        final recipients = await recipientService.getAllRecipient();
        await _saveOfflineData(recipients);
        state = RecipientTabState(
            status: RecipientTabStatus.loaded, recipientModel: recipients);
        await Future.delayed(Duration(seconds: 5));
      }
    } on SocketException {
      await _loadOfflineData();
    } catch (error) {
      if (mounted) {
        state = RecipientTabState(
          status: RecipientTabStatus.failed,
          errorMessage: error.toString(),
        );
        await _retryOnError();
      }
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
      final data = RecipientModel.fromJson(jsonDecode(securedData));
      state = RecipientTabState(
        status: RecipientTabStatus.loaded,
        recipientModel: data,
      );
    }
  }

  Future<void> _saveOfflineData(RecipientModel recipient) async {
    final encodedData = jsonEncode(recipient.toJson());
    await offlineData.writeRecipientsOfflineData(encodedData);
  }
}
