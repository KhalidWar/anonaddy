import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/pie_chart/pie_chart_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AliasScreenPieChart extends StatelessWidget {
  const AliasScreenPieChart({Key key, this.aliasDataModel}) : super(key: key);

  final AliasDataModel aliasDataModel;

  @override
  Widget build(BuildContext context) {
    final pieChartSectionRadius = 60.0;

    final emailsForwarded = aliasDataModel.emailsForwarded.toDouble();
    final emailsBlocked = aliasDataModel.emailsBlocked.toDouble();
    final emailsSent = aliasDataModel.emailsSent.toDouble();
    final emailsReplied = aliasDataModel.emailsReplied.toDouble();

    bool isPieChartEmpty() {
      if (emailsForwarded == 0.0 &&
          emailsBlocked == 0.0 &&
          emailsForwarded == 0.0 &&
          emailsSent == 0.0) {
        return true;
      } else {
        return false;
      }
    }

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.28,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20),
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
                        color: kFirstPieChartColor,
                        value: emailsForwarded,
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: kSecondPieChartColor,
                        value: emailsBlocked,
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: kThirdPieChartColor,
                        value: emailsSent,
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        radius: pieChartSectionRadius,
                        color: kFourthPieChartColor,
                        value: emailsReplied,
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
                  color: kFirstPieChartColor,
                  label: 'emails forwarded',
                  count: aliasDataModel.emailsForwarded,
                ),
                PieChartIndicator(
                  color: kSecondPieChartColor,
                  label: 'emails blocked',
                  count: aliasDataModel.emailsBlocked,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PieChartIndicator(
                  color: kFourthPieChartColor,
                  label: 'emails replied',
                  count: aliasDataModel.emailsReplied,
                ),
                PieChartIndicator(
                  color: kThirdPieChartColor,
                  label: 'emails sent',
                  count: aliasDataModel.emailsSent,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
