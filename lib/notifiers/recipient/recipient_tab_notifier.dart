import 'package:anonaddy/notifiers/recipient/recipient_tab_state.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientTabStateNotifier =
    StateNotifierProvider<RecipientTabNotifier, RecipientTabState>((ref) {
  return RecipientTabNotifier(recipientService: ref.read(recipientService));
});

class RecipientTabNotifier extends StateNotifier<RecipientTabState> {
  RecipientTabNotifier({
    required this.recipientService,
  }) : super(RecipientTabState.initialState());

  final RecipientService recipientService;

  void _updateState(RecipientTabState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchRecipients() async {
    _updateState(state.copyWith(status: RecipientTabStatus.loading));

    try {
      final recipients = await recipientService.getRecipients();
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

      final newState = state.copyWith(
          status: RecipientTabStatus.loaded, recipients: recipients);
      _updateState(newState);
    } catch (error) {
      final dioError = error as DioError;
      Utilities.showToast(dioError.message);
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
    try {
      final recipients = await recipientService.loadRecipientsFromDisk();
      final newState = state.copyWith(
        status: RecipientTabStatus.loaded,
        recipients: recipients,
      );
      _updateState(newState);
    } catch (error) {
      return;
    }
  }
}
