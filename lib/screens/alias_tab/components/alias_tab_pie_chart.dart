import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/pie_chart/pie_chart_indicator.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'aliases_stats_shimmer.dart';

class AliasTabPieChart extends StatelessWidget {
  const AliasTabPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.045),
      child: Consumer(
        builder: (context, watch, child) {
          final accountState = watch(accountStateNotifier);

          switch (accountState.status) {
            case AccountStatus.loading:
              return const AliasesStatsShimmer();

            case AccountStatus.loaded:
              final account = accountState.account!;
              return buildAliasStat(context: context, account: account);

            case AccountStatus.failed:
              return Center(
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
    final pieChartSectionRadius = 50.0;

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PieChartIndicator(
              color: kFirstPieChartColor,
              label: 'emails forwarded',
              count: emailsForwarded,
              textColor: Colors.white,
            ),
            SizedBox(height: size.height * 0.02),
            PieChartIndicator(
              color: kSecondPieChartColor,
              label: 'emails blocked',
              count: emailsBlocked,
              textColor: Colors.white,
            ),
            SizedBox(height: size.height * 0.02),
            PieChartIndicator(
              color: kFourthPieChartColor,
              label: 'emails replied',
              count: emailsReplied,
              textColor: Colors.white,
            ),
            SizedBox(height: size.height * 0.02),
            PieChartIndicator(
              color: kThirdPieChartColor,
              label: 'emails sent',
              count: emailsSent,
              textColor: Colors.white,
            ),
          ],
        ),
        Container(
          height: size.height * 0.18,
          width: size.height * 0.18,
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
                        color: kFirstPieChartColor,
                        value: emailsForwarded.toDouble(),
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: kSecondPieChartColor,
                        value: emailsBlocked.toDouble(),
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: kThirdPieChartColor,
                        value: emailsSent.toDouble(),
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: kFourthPieChartColor,
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
