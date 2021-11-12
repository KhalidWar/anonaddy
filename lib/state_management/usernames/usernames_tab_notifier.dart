import 'dart:convert';
import 'dart:io';

import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:anonaddy/state_management/lifecycle/lifecycle_state_manager.dart';
import 'package:anonaddy/state_management/usernames/usernames_tab_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameStateNotifier =
    StateNotifierProvider.autoDispose<UsernamesNotifier, UsernamesState>((ref) {
  return UsernamesNotifier(
    usernameService: ref.read(usernameService),
    offlineData: ref.read(offlineDataProvider),
    lifecycleStatus: ref.watch(lifecycleStateNotifier),
  );
});

class UsernamesNotifier extends StateNotifier<UsernamesState> {
  UsernamesNotifier({
    required this.usernameService,
    required this.offlineData,
    required this.lifecycleStatus,
  }) : super(UsernamesState(status: UsernamesStatus.loading)) {
    fetchUsernames();
  }

  final UsernameService usernameService;
  final OfflineData offlineData;
  final LifecycleStatus lifecycleStatus;

  Future fetchUsernames() async {
    try {
      final domains = await usernameService.getUsernameData();
      await _saveOfflineData(domains);
      state = UsernamesState(
        status: UsernamesStatus.loaded,
        usernameModel: domains,
      );
    } on SocketException {
      await _loadOfflineData();
    } catch (error) {
      if (mounted) {
        state = UsernamesState(
          status: UsernamesStatus.failed,
          errorMessage: error.toString(),
        );
        await _retryOnError();
      }
    }
  }

  Future _retryOnError() async {
    if (state.status == UsernamesStatus.failed) {
      await Future.delayed(Duration(seconds: 5));
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
