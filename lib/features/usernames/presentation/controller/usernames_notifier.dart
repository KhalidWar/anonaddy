import 'dart:async';

import 'package:anonaddy/features/usernames/data/username_service.dart';
import 'package:anonaddy/features/usernames/domain/username.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernamesNotifierProvider =
    AsyncNotifierProvider<UsernamesNotifier, List<Username>>(
        UsernamesNotifier.new);

class UsernamesNotifier extends AsyncNotifier<List<Username>> {
  Future<void> fetchUsernames() async {
    try {
      final usernames =
          await ref.read(usernameServiceProvider).fetchUsernames();
      state = AsyncData(usernames);
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.empty);
    }
  }

  @override
  FutureOr<List<Username>> build() async {
    final service = ref.read(usernameServiceProvider);

    final usernames = await service.loadUsernameFromDisk();
    if (usernames == null) return await service.fetchUsernames();
    return usernames;
  }
}
