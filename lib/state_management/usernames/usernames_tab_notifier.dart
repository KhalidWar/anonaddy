import 'dart:convert';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/username/username.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:anonaddy/state_management/usernames/usernames_tab_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameStateNotifier =
    StateNotifierProvider.autoDispose<UsernamesNotifier, UsernamesTabState>(
        (ref) {
  return UsernamesNotifier(
    usernameService: ref.read(usernameServiceProvider),
    offlineData: ref.read(offlineDataProvider),
  );
});

class UsernamesNotifier extends StateNotifier<UsernamesTabState> {
  UsernamesNotifier({
    required this.usernameService,
    required this.offlineData,
  }) : super(UsernamesTabState.initialState());

  final UsernameService usernameService;
  final OfflineData offlineData;

  /// Updates Usernames state
  void _updateState(UsernamesTabState newState) {
    if (mounted) state = newState;
  }

  Future<void> fetchUsernames() async {
    try {
      final domains = await usernameService.getUsernames();
      await _saveOfflineData(domains);
      final newState = state.copyWith(
        status: UsernamesStatus.loaded,
        usernames: domains,
      );
      _updateState(newState);
    } catch (error) {
      if (error == DioError) {
        final dioError = error as DioError;

        /// If offline, load offline data.
        if (dioError.type == DioErrorType.other) {
          await loadOfflineState();
        } else {
          final newState = state.copyWith(
            status: UsernamesStatus.failed,
            errorMessage: dioError.message,
          );
          _updateState(newState);
          await _retryOnError();
        }
      }
    }
  }

  Future<void> _retryOnError() async {
    if (state.status.isFailed()) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchUsernames();
    }
  }

  /// Fetches recipients from disk and displays them, used at initial app
  /// startup since fetching from disk is a lot faster than fetching from API.
  /// It's also used to when there's no internet connection.
  Future<void> loadOfflineState() async {
    /// Only load offline data when state is NOT failed.
    /// Otherwise, it would always show offline data even if there's error.
    if (!state.status.isFailed()) {
      List<dynamic> savedUsernames = [];
      final securedData = await offlineData.readUsernameOfflineData();
      if (securedData.isNotEmpty) savedUsernames = jsonDecode(securedData);
      final usernames = savedUsernames
          .map((username) => Username.fromJson(username))
          .toList();

      if (usernames.isNotEmpty) {
        final newState = state.copyWith(
          status: UsernamesStatus.loaded,
          usernames: usernames,
        );
        _updateState(newState);
      }
    }
  }

  Future<void> _saveOfflineData(List<Username> username) async {
    final encodedData = jsonEncode(username);
    await offlineData.writeUsernameOfflineData(encodedData);
  }
}
