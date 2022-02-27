import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/failed_deliveries/failed_deliveries_model.dart';
import 'package:anonaddy/screens/account_tab/components/paid_feature_wall.dart';
import 'package:anonaddy/shared_components/constants/addymanager_string.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FailedDeliveriesWidget extends ConsumerStatefulWidget {
  const FailedDeliveriesWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _FailedDeliveriesWidgetState();
}

class _FailedDeliveriesWidgetState
    extends ConsumerState<FailedDeliveriesWidget> {
  List<FailedDeliveries> failedDeliveries = [];

  Future<void> deleteFailedDelivery(String failedDeliveryId) async {
    final result = await ref
        .read(failedDeliveriesService)
        .deleteFailedDelivery(failedDeliveryId);
    if (result) {
      failedDeliveries.removeWhere((element) => element.id == failedDeliveryId);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    /// Insures Flutter has finished rendering frame
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      /// Fetches latest account data
      ref.read(accountStateNotifier.notifier).fetchAccount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountStateNotifier);
    switch (accountState.status) {
      case AccountStatus.loading:
        return loadingWidget(context);

      case AccountStatus.loaded:
        final subscription = accountState.account!.subscription;

        if (subscription == AnonAddyString.subscriptionFree) {
          return const PaidFeatureWall();
        }

        final failedDeliveriesAsync = ref.watch(failedDeliveriesProvider);
        return failedDeliveriesAsync.when(
          loading: () => loadingWidget(context),
          data: (data) {
            failedDeliveries = data.failedDeliveries;

            if (failedDeliveries.isEmpty) {
              return const Text('No failed deliveries found');
            } else {
              return failedDeliveriesList(data);
            }
          },
          error: (error, stackTrace) {
            return LottieWidget(
              lottie: LottieImages.errorCone,
              label: error.toString(),
            );
          },
        );

      case AccountStatus.failed:
        return LottieWidget(
          lottie: LottieImages.errorCone,
          lottieHeight: MediaQuery.of(context).size.height * 0.2,
          label: AppStrings.loadAccountDataFailed,
        );
    }
  }

  Widget failedDeliveriesList(FailedDeliveriesModel data) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: failedDeliveries.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final failedDeliveries = data.failedDeliveries[index];
        return ExpansionTile(
          expandedAlignment: Alignment.centerLeft,
          tilePadding: const EdgeInsets.all(0),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 5),
          title: Text(
            failedDeliveries.aliasEmail,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          subtitle: Text(
            failedDeliveries.code,
            style: Theme.of(context).textTheme.caption,
          ),
          children: [
            ListTile(
              dense: true,
              title: const Text('Alias'),
              subtitle: Text(failedDeliveries.aliasEmail),
            ),
            ListTile(
              dense: true,
              title: const Text('Recipient'),
              subtitle:
                  Text(failedDeliveries.recipientEmail ?? 'Not available'),
            ),
            ListTile(
              dense: true,
              title: const Text('Type'),
              subtitle: Text(failedDeliveries.bounceType),
            ),
            ListTile(
              dense: true,
              title: const Text('Code'),
              subtitle: Text(failedDeliveries.code),
            ),
            ListTile(
              dense: true,
              title: const Text('Remote MTA'),
              subtitle: Text(
                failedDeliveries.remoteMta.isEmpty
                    ? 'Not available'
                    : failedDeliveries.remoteMta,
              ),
            ),
            ListTile(
              dense: true,
              title: const Text('Created'),
              subtitle: Text(failedDeliveries.createdAt.toString()),
            ),
            const Divider(height: 0),
            TextButton(
              child: const Text('Delete failed delivery'),
              onPressed: () => deleteFailedDelivery(failedDeliveries.id),
            ),
          ],
        );
      },
    );
  }

  Widget loadingWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: const PlatformLoadingIndicator(),
    );
  }
}
