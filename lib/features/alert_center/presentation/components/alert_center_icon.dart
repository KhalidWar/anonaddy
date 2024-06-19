import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/features/alert_center/presentation/controller/local_notification_notifier.dart';
import 'package:anonaddy/features/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertCenterIcon extends StatelessWidget {
  const AlertCenterIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          key: const Key('homeScreenAppBarLeading'),
          tooltip: AppStrings.alertCenter,
          icon: const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          onPressed: () => context.pushRoute(const NotificationsScreenRoute()),
        ),
        Consumer(
          builder: (_, ref, __) {
            final localNotificationAsync =
                ref.watch(localNotificationNotifierProvider);

            return localNotificationAsync.when(
              data: (localNotifications) {
                if (localNotifications.isNotEmpty) {
                  return Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
              error: (_, __) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            );
          },
        )
      ],
    );
  }
}
