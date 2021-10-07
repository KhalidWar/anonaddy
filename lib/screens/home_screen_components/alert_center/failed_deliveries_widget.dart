import 'package:anonaddy/models/failed_deliveries/failed_deliveries_model.dart';
import 'package:anonaddy/screens/account_tab/components/paid_feature_wall.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_providers.dart';

class FailedDeliveriesWidget extends StatefulWidget {
  const FailedDeliveriesWidget({Key? key}) : super(key: key);

  @override
  State<FailedDeliveriesWidget> createState() => _FailedDeliveriesWidgetState();
}

class _FailedDeliveriesWidgetState extends State<FailedDeliveriesWidget> {
  List<FailedDeliveries> failedDeliveries = [];

  Future<void> deleteFailedDelivery(String failedDeliveryId) async {
    final result = await context
        .read(failedDeliveriesService)
        .deleteFailedDelivery(failedDeliveryId);
    if (result) {
      failedDeliveries.removeWhere((element) => element.id == failedDeliveryId);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final accountState = watch(accountStateNotifier);
        switch (accountState.status) {
          case AccountStatus.loading:
            return loadingWidget(context);

          case AccountStatus.loaded:
            final subscription =
                accountState.accountModel!.account.subscription;

            if (subscription == kFreeSubscription) {
              return PaidFeatureWall();
            }

            final failedDeliveriesAsync = watch(failedDeliveriesProvider);
            return failedDeliveriesAsync.when(
              loading: () => loadingWidget(context),
              data: (data) {
                failedDeliveries = data.failedDeliveries;

                if (failedDeliveries.isEmpty) {
                  return Text('No failed deliveries found');
                } else {
                  return failedDeliveriesList(data);
                }
              },
              error: (error, stackTrace) {
                return LottieWidget(
                  lottie: 'assets/lottie/errorCone.json',
                  label: error.toString(),
                );
              },
            );

          case AccountStatus.failed:
            return LottieWidget(
              lottie: 'assets/lottie/errorCone.json',
              lottieHeight: MediaQuery.of(context).size.height * 0.2,
              label: kLoadAccountDataFailed,
            );
        }
      },
    );
  }

  Widget failedDeliveriesList(FailedDeliveriesModel data) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: failedDeliveries.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final failedDeliveries = data.failedDeliveries[index];
        return ExpansionTile(
          expandedAlignment: Alignment.centerLeft,
          tilePadding: EdgeInsets.all(0),
          childrenPadding: EdgeInsets.symmetric(horizontal: 5),
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
              title: Text('Alias'),
              subtitle: Text(failedDeliveries.aliasEmail),
            ),
            ListTile(
              dense: true,
              title: Text('Recipient'),
              subtitle:
                  Text(failedDeliveries.recipientEmail ?? 'Not available'),
            ),
            ListTile(
              dense: true,
              title: Text('Type'),
              subtitle: Text(failedDeliveries.bounceType),
            ),
            ListTile(
              dense: true,
              title: Text('Code'),
              subtitle: Text(failedDeliveries.code),
            ),
            ListTile(
              dense: true,
              title: Text('Remote MTA'),
              subtitle: Text(
                failedDeliveries.remoteMta.isEmpty
                    ? 'Not available'
                    : failedDeliveries.remoteMta,
              ),
            ),
            ListTile(
              dense: true,
              title: Text('Created'),
              subtitle: Text(failedDeliveries.createdAt.toString()),
            ),
            Divider(height: 0),
            TextButton(
              child: Text('Delete failed delivery'),
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
      padding: EdgeInsets.all(20),
      child: CircularProgressIndicator(),
    );
  }
}