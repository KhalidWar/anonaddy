import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/custom_app_bar.dart';
import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/shimmer_effects/shimmering_list_tile.dart';
import 'package:anonaddy/features/alert_center/presentation/controller/local_notification_notifier.dart';
import 'package:anonaddy/features/monetization/presentation/monetization_paywall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  static const routeName = 'notificationsScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localNotifications = ref.watch(localNotificationNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.notifications,
        leadingOnPress: () => Navigator.pop(context),
        showTrailing: false,
      ),
      body: MonetizationPaywall(
        child: localNotifications.when(
          data: (localNotifications) {
            if (localNotifications.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Nothing to see here!'),
              );
            }

            return ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: localNotifications.length,
              itemBuilder: (context, index) {
                final notification = localNotifications[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.notifications),
                  title: Text(notification.title),
                  subtitle: Text(notification.subtitle),
                  onTap: notification.payload == null ? null : () {},
                );
              },
            );
          },
          error: (error, __) => ErrorMessageWidget(message: error.toString()),
          loading: () => const ShimmeringListTile(),
        ),
      ),
    );
  }
}
