import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/failed_deliveries/failed_deliveries_model.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertCenterScreen extends StatefulWidget {
  const AlertCenterScreen({Key? key}) : super(key: key);

  @override
  _AlertCenterScreenState createState() => _AlertCenterScreenState();
}

class _AlertCenterScreenState extends State<AlertCenterScreen> {
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Alert Center')),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeadline('Notifications'),
              Text(
                'One central location for your account alerts and notifications.',
                style: Theme.of(context).textTheme.caption,
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.all(20),
                child: LottieWidget(
                  lottie: 'assets/lottie/coming_soon.json',
                  repeat: true,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeadline('Failed deliveries'),
              Text(
                kFailedDeliveriesNote,
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: 10),
              buildFailedDeliveries(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadline(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.headline6,
        ),
        Divider(),
      ],
    );
  }

  Widget buildFailedDeliveries() {
    return Consumer(
      builder: (context, watch, child) {
        final account = context.read(accountStreamProvider).data;

        if (account == null) {
          return LottieWidget(
            lottie: 'assets/lottie/errorCone.json',
            lottieHeight: MediaQuery.of(context).size.height * 0.2,
            label: kLoadAccountDataFailed,
          );
        }

        if (account.value.account.subscription == kFreeSubscription) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              kSubscriptionInfoText,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }

        final failedDeliveriesAsync = watch(failedDeliveriesProvider);
        return failedDeliveriesAsync.when(
          loading: () => Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
          data: (data) {
            failedDeliveries = data.failedDeliveries;

            if (failedDeliveries.isEmpty)
              return Text('No failed deliveries found');
            else
              return ListView.builder(
                shrinkWrap: true,
                itemCount: failedDeliveries.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final failedDeliveries = data.failedDeliveries[index];
                  return ExpansionTile(
                    backgroundColor: Colors.grey.shade200,
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
                        subtitle: Text(
                            failedDeliveries.recipientEmail ?? 'Not available'),
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
                        onPressed: () =>
                            deleteFailedDelivery(failedDeliveries.id),
                      ),
                    ],
                  );
                },
              );
          },
          error: (error, stackTrace) {
            return LottieWidget(
              lottie: 'assets/lottie/errorCone.json',
              label: error.toString(),
            );
          },
        );
      },
    );
  }
}
