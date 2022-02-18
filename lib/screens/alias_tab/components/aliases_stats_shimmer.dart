import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/pie_chart/pie_chart_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AliasesStatsShimmer extends StatelessWidget {
  const AliasesStatsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const pieChartSectionRadius = 50.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PieChartIndicator(
              color: kFirstPieChartColor,
              label: 'emails forwarded',
              count: 0,
              textColor: Colors.white,
            ),
            SizedBox(height: size.height * 0.02),
            const PieChartIndicator(
              color: kSecondPieChartColor,
              label: 'emails blocked',
              count: 0,
              textColor: Colors.white,
            ),
            SizedBox(height: size.height * 0.02),
            const PieChartIndicator(
              color: kFourthPieChartColor,
              label: 'emails replied',
              count: 0,
              textColor: Colors.white,
            ),
            SizedBox(height: size.height * 0.02),
            const PieChartIndicator(
              color: kThirdPieChartColor,
              label: 'emails sent',
              count: 0,
              textColor: Colors.white,
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.18,
          width: size.height * 0.18,
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              sections: [
                PieChartSectionData(
                  showTitle: false,
                  radius: pieChartSectionRadius,
                  color: Colors.white54,
                  value: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
