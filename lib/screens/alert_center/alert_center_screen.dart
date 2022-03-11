import 'package:anonaddy/screens/alert_center/components/alert_header.dart';
import 'package:anonaddy/screens/alert_center/components/section_separator.dart';
import 'package:anonaddy/screens/alert_center/failed_deliveries_widget.dart';
import 'package:anonaddy/screens/alert_center/notifications_widget.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:flutter/material.dart';

class AlertCenterScreen extends StatelessWidget {
  const AlertCenterScreen({Key? key}) : super(key: key);

  static const routeName = 'alertCenterScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.alertCenter)),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        children: const [
          AlertHeader(
            title: AppStrings.notifications,
            subtitle: AppStrings.notificationsNote,
          ),
          NotificationsWidget(),
          SectionSeparator(),
          AlertHeader(
            title: AppStrings.failedDeliveries,
            subtitle: AppStrings.failedDeliveriesNote,
          ),
          FailedDeliveriesWidget(),
          SectionSeparator(),
        ],
      ),
    );
  }
}
