import 'package:anonaddy/screens/account_tab/components/paid_feature_wall.dart';
import 'package:anonaddy/screens/alert_center/components/failed_delivery_list_tile.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/state_management/failed_delivery/failed_delivery_notifier.dart';
import 'package:anonaddy/state_management/failed_delivery/failed_delivery_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FailedDeliveriesWidget extends ConsumerStatefulWidget {
  const FailedDeliveriesWidget({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FailedDeliveriesWidgetState();
}

class _FailedDeliveriesWidgetState
    extends ConsumerState<FailedDeliveriesWidget> {
  @override
  void initState() {
    super.initState();

    /// Insures Flutter has finished rendering frame
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      /// Fetches latest account data first to get the latest subscription status.
      ref.read(accountStateNotifier.notifier).fetchAccount().then((value) {
        /// Then, fetches Failed deliveries.
        ref.read(failedDeliveryStateNotifier.notifier).getFailedDeliveries();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountStateNotifier);
    switch (accountState.status) {
      case AccountStatus.loading:
        return const Center(child: PlatformLoadingIndicator());

      case AccountStatus.loaded:
        final subscription = accountState.account!.subscription;

        if (subscription == AnonAddyString.subscriptionFree) {
          return const PaidFeatureWall();
        }

        final failedDeliveryState = ref.watch(failedDeliveryStateNotifier);
        switch (failedDeliveryState.status) {
          case FailedDeliveryStatus.loading:
            return const Center(child: PlatformLoadingIndicator());

          case FailedDeliveryStatus.loaded:
            final deliveries = failedDeliveryState.failedDeliveries;

            if (deliveries.isEmpty) {
              return const Text('No failed deliveries found');
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: deliveries.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final failedDelivery = deliveries[index];
                  return FailedDeliveryListTile(
                    delivery: failedDelivery,
                    onPress: () => ref
                        .read(failedDeliveryStateNotifier.notifier)
                        .deleteFailedDelivery(failedDelivery.id),
                  );
                },
              );
            }

          case FailedDeliveryStatus.failed:
            final error = failedDeliveryState.errorMessage;
            return LottieWidget(
              lottie: LottieImages.errorCone,
              label: error,
            );
        }

      case AccountStatus.failed:
        return LottieWidget(
          lottie: LottieImages.errorCone,
          lottieHeight: MediaQuery.of(context).size.height * 0.2,
          label: AppStrings.loadAccountDataFailed,
        );
    }
  }
}
