import 'dart:async';

import 'package:anonaddy/features/alert_center/domain/local_notification.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localNotificationNotifierProvider = AsyncNotifierProvider.autoDispose<
    LocalNotificationNotifier,
    List<LocalNotification>>(LocalNotificationNotifier.new);

class LocalNotificationNotifier
    extends AutoDisposeAsyncNotifier<List<LocalNotification>> {
  Future<LocalNotification?> checkAccessTokenExpiration() async {
    final user = ref.watch(authStateNotifier).value!.user!;
    final apiTokenExpirationDate = user.apiToken.expiresAt;

    if (apiTokenExpirationDate == null) return null;

    final weekFromNow = DateTime.now().add(const Duration(days: 7));
    final remainingDays =
        apiTokenExpirationDate.difference(DateTime.now()).inDays;

    if (apiTokenExpirationDate.isBefore(weekFromNow)) {
      return LocalNotification(
        title: 'API Token Expires in $remainingDays days',
        subtitle: 'To avoid interruptions, please login again.',
        payload: '',
        dismissable: false,
      );
    }

    return null;
  }

  @override
  FutureOr<List<LocalNotification>> build() async {
    final tokenExpirationNotification = await checkAccessTokenExpiration();

    if (tokenExpirationNotification == null) return [];

    return [tokenExpirationNotification];
  }
}
