import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/pie_chart/pie_chart_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AliasScreenPieChart extends StatelessWidget {
  const AliasScreenPieChart({
    super.key,
    required this.emailsForwarded,
    required this.emailsBlocked,
    required this.emailsSent,
    required this.emailsReplied,
  });

  final int emailsForwarded;
  final int emailsBlocked;
  final int emailsSent;
  final int emailsReplied;

  @override
  Widget build(BuildContext context) {
    const pieChartSectionRadius = 60.0;

    bool isPieChartEmpty() {
      if (emailsForwarded == 0 &&
          emailsBlocked == 0 &&
          emailsForwarded == 0 &&
          emailsSent == 0) {
        return true;
      } else {
        return false;
      }
    }

    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              sections: isPieChartEmpty()
                  ? [
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: Colors.grey[400],
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PieChartIndicator(
                  color: AppColors.firstPieChartColor,
                  label: 'emails forwarded',
                  count: emailsForwarded,
                ),
                PieChartIndicator(
                  color: AppColors.secondPieChartColor,
                  label: 'emails blocked',
                  count: emailsBlocked,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PieChartIndicator(
                  color: AppColors.fourthPieChartColor,
                  label: 'emails replied',
                  count: emailsReplied,
                ),
                PieChartIndicator(
                  color: AppColors.thirdPieChartColor,
                  label: 'emails sent',
                  count: emailsSent,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
