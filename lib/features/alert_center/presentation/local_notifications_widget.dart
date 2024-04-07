import 'package:anonaddy/features/alert_center/presentation/controller/local_notification_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalNotificationsWidget extends ConsumerStatefulWidget {
  const LocalNotificationsWidget({super.key});

  @override
  ConsumerState createState() => _LocalNotificationsWidgetState();
}

class _LocalNotificationsWidgetState
    extends ConsumerState<LocalNotificationsWidget> {
  @override
  Widget build(BuildContext context) {
    final localNotifications = ref.watch(localNotificationNotifierProvider);

    return localNotifications.when(
      data: (localNotifications) {
        if (localNotifications.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Nothing to see here!'),
          );
        }

        return Container();
      },
      error: (err, stack) => Container(),
      loading: () => Container(),
    );
  }
}
