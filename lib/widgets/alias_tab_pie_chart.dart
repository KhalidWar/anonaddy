import 'package:anonaddy/widgets/pie_chart_indicator.dart';
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

  @override
  Widget build(BuildContext context) {
    final firstPieceColor = Color(0xff0293ee);
    final secondPieceColor = Color(0xfff8b250);
    final thirdPieceColor = Color(0xff845bef);
    final fourthPieceColor = Color(0xff13d38e);
    final pieChartSectionRadius = 50.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PieChartIndicator(
              color: firstPieceColor,
              label: 'emails forwarded',
              count: emailsForwarded,
              textColor: Colors.white,
            ),
            SizedBox(height: 20),
            PieChartIndicator(
              color: secondPieceColor,
              label: 'emails blocked',
              count: emailsBlocked,
              textColor: Colors.white,
            ),
            SizedBox(height: 20),
            PieChartIndicator(
              color: fourthPieceColor,
              label: 'emails replied',
              count: emailsReplied,
              textColor: Colors.white,
            ),
            SizedBox(height: 20),
            PieChartIndicator(
              color: thirdPieceColor,
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
              sections: [
                PieChartSectionData(
                  showTitle: false,
                  radius: pieChartSectionRadius,
                  color: firstPieceColor,
                  value: emailsForwarded.toDouble(),
                ),
                PieChartSectionData(
                  showTitle: false,
                  radius: pieChartSectionRadius,
                  color: secondPieceColor,
                  value: emailsBlocked.toDouble(),
                ),
                PieChartSectionData(
                  showTitle: false,
                  radius: pieChartSectionRadius,
                  color: thirdPieceColor,
                  value: emailsSent.toDouble(),
                ),
                PieChartSectionData(
                  showTitle: false,
                  radius: pieChartSectionRadius,
                  color: fourthPieceColor,
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
