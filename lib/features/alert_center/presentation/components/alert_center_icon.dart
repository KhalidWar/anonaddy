import 'package:anonaddy/features/alert_center/presentation/alert_center_screen.dart';
import 'package:anonaddy/features/alert_center/presentation/controller/failed_delivery_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertCenterIcon extends StatelessWidget {
  const AlertCenterIcon({Key? key}) : super(key: key);

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
          onPressed: () {
            Navigator.pushNamed(context, AlertCenterScreen.routeName);
          },
        ),
        Consumer(
          builder: (_, ref, __) {
            final failedDeliveries = ref.watch(failedDeliveriesNotifier);

            return failedDeliveries.when(
              data: (failedDeliveries) {
                if (failedDeliveries.isNotEmpty) {
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

                return Container();
              },
              error: (_, __) => Container(),
              loading: () => Container(),
            );
          },
        )
      ],
    );
  }
}
