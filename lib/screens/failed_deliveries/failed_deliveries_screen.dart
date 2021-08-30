import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FailedDeliveriesScreen extends StatefulWidget {
  const FailedDeliveriesScreen({Key? key}) : super(key: key);

  @override
  _FailedDeliveriesScreenState createState() => _FailedDeliveriesScreenState();
}

class _FailedDeliveriesScreenState extends State<FailedDeliveriesScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text(kFailedDeliveriesNote),
          Divider(height: size.height * 0.05),
          Center(
            child: Consumer(
              builder: (context, watch, child) {
                final failedDeliveriesAsync = watch(failedDeliveriesProvider);
                return failedDeliveriesAsync.when(
                  loading: () => CircularProgressIndicator(),
                  data: (data) {
                    final failedDeliveries = data.failedDeliveries;

                    if (failedDeliveries.isEmpty)
                      return Text('No failed deliveries found');
                    else
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(20),
                        itemCount: failedDeliveries.length,
                        itemBuilder: (context, index) {
                          final failedDeliveries = data.failedDeliveries[index];

                          return ListTile(
                            title: Text(failedDeliveries.aliasEmail),
                            subtitle: Text(failedDeliveries.code),
                            trailing: Icon(Icons.warning),
                            onTap: () {},
                          );
                        },
                      );
                  },
                  error: (error, stackTrace) {
                    return LottieWidget(
                      showLoading: true,
                      lottie: 'assets/lottie/errorCone.json',
                      label: error.toString(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Failed Deliveries'),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {},
        ),
      ],
    );
  }
}
