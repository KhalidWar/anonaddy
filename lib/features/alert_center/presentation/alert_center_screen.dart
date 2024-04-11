import 'package:anonaddy/features/alert_center/presentation/components/alert_header.dart';
import 'package:anonaddy/features/alert_center/presentation/failed_deliveries_widget.dart';
import 'package:anonaddy/features/alert_center/presentation/local_notifications_widget.dart';
import 'package:anonaddy/features/monetization/presentation/monetization_paywall.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/custom_app_bar.dart';
import 'package:anonaddy/shared_components/paid_feature_blocker.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:flutter/material.dart';

class AlertCenterScreen extends StatelessWidget {
  const AlertCenterScreen({super.key});

  static const routeName = 'alertCenterScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.alertCenter,
        leadingOnPress: () => Navigator.pop(context),
        showTrailing: false,
      ),
      body: MonetizationPaywall(
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          children: const [
            AlertHeader(
              title: AppStrings.notifications,
              subtitle: AppStrings.notificationsNote,
            ),
            LocalNotificationsWidget(),
            SizedBox(height: 16),
            AlertHeader(
              title: AppStrings.failedDeliveries,
              subtitle: AppStrings.failedDeliveriesNote,
            ),
            PaidFeatureBlocker(
              loadingWidget: Center(child: PlatformLoadingIndicator()),
              child: FailedDeliveriesWidget(),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
