import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:anonaddy/state_management/usernames/usernames_tab_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameStateNotifier =
    StateNotifierProvider.autoDispose<UsernamesNotifier, UsernamesState>((ref) {
  return UsernamesNotifier(
    usernameService: ref.read(usernameServiceProvider),
    offlineData: ref.read(offlineDataProvider),
  );
});

class UsernamesNotifier extends StateNotifier<UsernamesState> {
  UsernamesNotifier({
    required this.usernameService,
    required this.offlineData,
  }) : super(const UsernamesState(status: UsernamesStatus.loading)) {
    fetchUsernames();
  }

  final UsernameService usernameService;
  final OfflineData offlineData;

  /// Updates Usernames state
  void _updateState(UsernamesState newState) {
    if (mounted) state = newState;
  }

  Future fetchUsernames() async {
    try {
      final domains = await usernameService.getUsernames();
      await _saveOfflineData(domains);
      final newState = UsernamesState(
        status: UsernamesStatus.loaded,
        usernameModel: domains,
      );
      _updateState(newState);
    } on SocketException {
      await _loadOfflineData();
    } catch (error) {
      final dioError = error as DioError;
      final newState = UsernamesState(
        status: UsernamesStatus.failed,
        errorMessage: dioError.message,
      );
      _updateState(newState);
      await _retryOnError();
    }
  }

  Future _retryOnError() async {
    if (state.status == UsernamesStatus.failed) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchUsernames();
    }
  }

  Future<void> _loadOfflineData() async {
    final securedData = await offlineData.readUsernameOfflineData();
    if (securedData.isNotEmpty) {
      final data = UsernameModel.fromJson(jsonDecode(securedData));
      state = UsernamesState(
        status: UsernamesStatus.loaded,
        usernameModel: data,
      );
    }
  }

  Future<void> _saveOfflineData(UsernameModel username) async {
    final encodedData = jsonEncode(username.toJson());
    await offlineData.writeUsernameOfflineData(encodedData);
  }
}
