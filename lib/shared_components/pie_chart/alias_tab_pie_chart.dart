import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/pie_chart/pie_chart_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AliasTabPieChart extends StatelessWidget {
  const AliasTabPieChart(
      {Key key,
      this.emailsForwarded,
      this.emailsBlocked,
      this.emailsReplied,
      this.emailsSent})
      : super(key: key);

  final int emailsForwarded, emailsBlocked, emailsReplied, emailsSent;

  bool _isPieChartEmpty() {
    if (emailsForwarded == 0 &&
        emailsBlocked == 0 &&
        emailsForwarded == 0 &&
        emailsSent == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pieChartSectionRadius = 50.0;

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
            SizedBox(height: 20),
            PieChartIndicator(
              color: kSecondPieChartColor,
              label: 'emails blocked',
              count: emailsBlocked,
              textColor: Colors.white,
            ),
            SizedBox(height: 20),
            PieChartIndicator(
              color: kFourthPieChartColor,
              label: 'emails replied',
              count: emailsReplied,
              textColor: Colors.white,
            ),
            SizedBox(height: 20),
            PieChartIndicator(
              color: kThirdPieChartColor,
              label: 'emails sent',
              count: emailsSent,
              textColor: Colors.white,
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.18,
          width: MediaQuery.of(context).size.height * 0.18,
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              sections: _isPieChartEmpty()
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
