import 'dart:async';

import 'package:anonaddy/features/alert_center/domain/local_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localNotificationNotifierProvider = AsyncNotifierProvider.autoDispose<
    LocalNotificationNotifier,
    List<LocalNotification>>(LocalNotificationNotifier.new);

class LocalNotificationNotifier
    extends AutoDisposeAsyncNotifier<List<LocalNotification>> {
  @override
  FutureOr<List<LocalNotification>> build() async {
    return [];
  }
}
