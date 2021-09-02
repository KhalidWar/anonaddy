import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/failed_deliveries/failed_deliveries_model.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FailedDeliveriesScreen extends StatefulWidget {
  const FailedDeliveriesScreen({Key? key}) : super(key: key);

  @override
  _FailedDeliveriesScreenState createState() => _FailedDeliveriesScreenState();
}

class _FailedDeliveriesScreenState extends State<FailedDeliveriesScreen> {
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
    return Scaffold(
      appBar: AppBar(title: Text('Failed Deliveries')),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(kFailedDeliveriesNote),
          ),
          Divider(height: 0),
          Consumer(
            builder: (context, watch, child) {
              final failedDeliveriesAsync = watch(failedDeliveriesProvider);
              return failedDeliveriesAsync.when(
                loading: () => buildLoading(),
                data: (data) {
                  failedDeliveries = data.failedDeliveries;

                  if (failedDeliveries.isEmpty)
                    return Center(child: Text('No failed deliveries found'));
                  else
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: failedDeliveries.length,
                      itemBuilder: (context, index) {
                        final failedDeliveries = data.failedDeliveries[index];
                        return ExpansionTile(
                          backgroundColor: Colors.grey.shade200,
                          expandedAlignment: Alignment.centerLeft,
                          tilePadding: EdgeInsets.all(10),
                          childrenPadding: EdgeInsets.symmetric(horizontal: 5),
                          title: Text(failedDeliveries.aliasEmail,
                              style: Theme.of(context).textTheme.bodyText1),
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
                              subtitle: Text(failedDeliveries.recipientEmail ??
                                  'Not available'),
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
                              subtitle:
                                  Text(failedDeliveries.createdAt.toString()),
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
          ),
        ],
      ),
    );
  }

  Widget buildLoading() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child: CircularProgressIndicator(),
    );
  }
}
