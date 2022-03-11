import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/screens/alias_tab/components/aliases_stats_shimmer.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/pie_chart/pie_chart_indicator.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasTabPieChart extends StatelessWidget {
  const AliasTabPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.05),
      child: Consumer(
        builder: (context, ref, child) {
          final accountState = ref.watch(accountStateNotifier);

          switch (accountState.status) {
            case AccountStatus.loading:
              return const AliasesStatsShimmer();

            case AccountStatus.loaded:
              final account = accountState.account!;
              return buildAliasStat(context: context, account: account);

            case AccountStatus.failed:
              return const Center(
                child: Text(
                  'Failed to load data',
                  style: TextStyle(color: Colors.white),
                ),
              );
          }
        },
      ),
    );
  }

  Widget buildAliasStat(
      {required BuildContext context, required Account account}) {
    final size = MediaQuery.of(context).size;
    final sectionWidth = size.width * 0.4;
    const pieChartSectionRadius = 50.0;

    final emailsForwarded = account.totalEmailsForwarded;
    final emailsBlocked = account.totalEmailsBlocked;
    final emailsReplied = account.totalEmailsReplied;
    final emailsSent = account.totalEmailsSent;

    bool isPieChartEmpty() {
      if (emailsForwarded == 0 &&
          emailsBlocked == 0 &&
          emailsReplied == 0 &&
          emailsSent == 0) {
        return true;
      } else {
        return false;
      }
    }

    Widget indicatorSeparator() {
      return const SizedBox(height: 10);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: sectionWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PieChartIndicator(
                color: AppColors.firstPieChartColor,
                label: 'emails forwarded',
                count: emailsForwarded,
                textColor: Colors.white,
              ),
              indicatorSeparator(),
              PieChartIndicator(
                color: AppColors.secondPieChartColor,
                label: 'emails blocked',
                count: emailsBlocked,
                textColor: Colors.white,
              ),
              indicatorSeparator(),
              PieChartIndicator(
                color: AppColors.fourthPieChartColor,
                label: 'emails replied',
                count: emailsReplied,
                textColor: Colors.white,
              ),
              indicatorSeparator(),
              PieChartIndicator(
                color: AppColors.thirdPieChartColor,
                label: 'emails sent',
                count: emailsSent,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
        SizedBox(
          width: sectionWidth,
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              sections: isPieChartEmpty()
                  ? [
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: Colors.white54,
                        value: 1,
                      ),
                    ]
                  : [
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: AppColors.firstPieChartColor,
                        value: emailsForwarded.toDouble(),
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: AppColors.secondPieChartColor,
                        value: emailsBlocked.toDouble(),
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: AppColors.thirdPieChartColor,
                        value: emailsSent.toDouble(),
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: AppColors.fourthPieChartColor,
                        value: emailsReplied.toDouble(),
                      ),
                    ],
            ),
          ),
        ),
      ],
    );
  }
}
