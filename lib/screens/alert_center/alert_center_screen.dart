import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:flutter/material.dart';

import 'failed_deliveries_widget.dart';

class AlertCenterScreen extends StatefulWidget {
  const AlertCenterScreen({Key? key}) : super(key: key);

  static const routeName = 'alertCenterScreen';

  @override
  _AlertCenterScreenState createState() => _AlertCenterScreenState();
}

class _AlertCenterScreenState extends State<AlertCenterScreen> {
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
              FailedDeliveriesWidget(),
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
}
