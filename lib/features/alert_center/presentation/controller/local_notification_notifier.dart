import 'dart:async';

import 'package:anonaddy/features/alert_center/data/failed_delivery_service.dart';
import 'package:anonaddy/features/alert_center/domain/local_notification.dart';
import 'package:anonaddy/features/app_version/data/app_version_service.dart';
import 'package:anonaddy/features/auth/domain/user.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localNotificationNotifierProvider = AsyncNotifierProvider.autoDispose<
    LocalNotificationNotifier,
    List<LocalNotification>>(LocalNotificationNotifier.new);

class LocalNotificationNotifier
    extends AutoDisposeAsyncNotifier<List<LocalNotification>> {
  Future<List<LocalNotification>?> getFailedDeliveries() async {
    try {
      final failedDeliveries =
          await ref.read(failedDeliveryService).getFailedDeliveries();

      if (failedDeliveries.isNotEmpty) {
        return failedDeliveries.map((delivery) {
          return LocalNotification(
            title: 'Failed Delivery',
            subtitle: delivery.recipientEmail ?? 'Unknown Recipient',
            payload: delivery.id,
            dismissable: false,
          );
        }).toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<LocalNotification?> getAccessTokenExpiryNotification() async {
    try {
      final user = ref.read(authStateNotifier).value!.user!;
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
    } catch (_) {
      return null;
    }
  }

  Future<LocalNotification?> getAppVersionNotification() async {
    try {
      final user = ref.read(authStateNotifier).value!.user!;
      if (!user.isSelfHosting) return null;

      final latestAppVersion =
          await ref.read(appVersionService).fetchLatestAddyAppVersion();
      final currentAppVersion =
          await ref.read(appVersionService).getAppVersionData();
      final formattedCurrentVersion = 'v${currentAppVersion.version}';

      if (formattedCurrentVersion != latestAppVersion) {
        return LocalNotification(
          title: 'Self-hosted instance version is available!',
          subtitle: 'Update to latest version ',
          payload: '',
          dismissable: false,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  FutureOr<List<LocalNotification>> build() async {
    final locationNotifications = <LocalNotification>[];

    final failedDeliveriesNotification = await getFailedDeliveries();
    final tokenExpiryNotification = await getAccessTokenExpiryNotification();
    final appVersionNotification = await getAppVersionNotification();

    locationNotifications.addAll([
      if (failedDeliveriesNotification != null) ...failedDeliveriesNotification,
      if (tokenExpiryNotification != null) tokenExpiryNotification,
      if (appVersionNotification != null) appVersionNotification,
    ]);

    return locationNotifications;
  }
}
