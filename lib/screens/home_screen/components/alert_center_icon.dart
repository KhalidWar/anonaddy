import 'package:anonaddy/screens/alert_center/alert_center_screen.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/state_management/failed_delivery/failed_delivery_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertCenterIcon extends ConsumerWidget {
  const AlertCenterIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failedDeliveries =
        ref.watch(failedDeliveryStateNotifier).failedDeliveries;

    return Stack(
      children: [
        IconButton(
          key: const Key('homeScreenAppBarLeading'),
          tooltip: AppStrings.alertCenter,
          icon: const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, AlertCenterScreen.routeName);
          },
        ),
        if (failedDeliveries.isNotEmpty)
          Positioned(
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
          ),
      ],
    );
  }
}
