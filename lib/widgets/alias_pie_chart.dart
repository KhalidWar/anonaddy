import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/widgets/pie_chart_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AliasPieChart extends StatelessWidget {
  const AliasPieChart({Key key, this.aliasDataModel}) : super(key: key);

  final AliasDataModel aliasDataModel;

  @override
  Widget build(BuildContext context) {
    final firstPieceColor = Color(0xff0293ee);
    final secondPieceColor = Color(0xfff8b250);
    final thirdPieceColor = Color(0xff845bef);
    final fourthPieceColor = Color(0xff13d38e);

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              startDegreeOffset: 0,
              sections: [
                PieChartSectionData(
                  showTitle: false,
                  color: firstPieceColor,
                  value: aliasDataModel.emailsForwarded.toDouble(),
                ),
                PieChartSectionData(
                  showTitle: false,
                  color: secondPieceColor,
                  value: aliasDataModel.emailsBlocked.toDouble(),
                ),
                PieChartSectionData(
                  showTitle: false,
                  color: thirdPieceColor,
                  value: aliasDataModel.emailsSent.toDouble(),
                ),
                PieChartSectionData(
                  showTitle: false,
                  color: fourthPieceColor,
                  value: aliasDataModel.emailsReplied.toDouble(),
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
                  color: firstPieceColor,
                  label: 'Forwarded',
                  count: aliasDataModel.emailsForwarded,
                ),
                PieChartIndicator(
                  color: secondPieceColor,
                  label: 'Blocked',
                  count: aliasDataModel.emailsBlocked,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PieChartIndicator(
                  color: fourthPieceColor,
                  label: 'Replied',
                  count: aliasDataModel.emailsReplied,
                ),
                PieChartIndicator(
                  color: thirdPieceColor,
                  label: 'Sent',
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
