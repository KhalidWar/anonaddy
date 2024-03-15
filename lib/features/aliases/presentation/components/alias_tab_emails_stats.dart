import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/pie_chart/pie_chart_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasTabEmailsStats extends ConsumerWidget {
  const AliasTabEmailsStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountNotifierProvider);

    return accountState.when(
      data: (account) {
        return AliasTabEmailsPieChart(
          emailsForwarded: account.totalEmailsForwarded,
          emailsBlocked: account.totalEmailsBlocked,
          emailsReplied: account.totalEmailsReplied,
          emailsSent: account.totalEmailsSent,
        );
      },
      error: (_, __) {
        return const AliasTabEmailsPieChart(
          emailsForwarded: 0,
          emailsBlocked: 0,
          emailsReplied: 0,
          emailsSent: 0,
        );
      },
      loading: () {
        return const AliasTabEmailsPieChart(
          emailsForwarded: 0,
          emailsBlocked: 0,
          emailsReplied: 0,
          emailsSent: 0,
        );
      },
    );
  }
}

class AliasTabEmailsPieChart extends StatelessWidget {
  const AliasTabEmailsPieChart({
    Key? key,
    required this.emailsForwarded,
    required this.emailsBlocked,
    required this.emailsReplied,
    required this.emailsSent,
  }) : super(key: key);

  final int emailsForwarded;
  final int emailsBlocked;
  final int emailsReplied;
  final int emailsSent;

  static const _pieChartSectionRadius = 50.0;

  bool isPieChartEmpty() {
    return emailsForwarded == 0 &&
        emailsBlocked == 0 &&
        emailsReplied == 0 &&
        emailsSent == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 50),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PieChartIndicator(
                    color: AppColors.firstPieChartColor,
                    label: 'forwarded',
                    count: emailsForwarded,
                    textColor: Colors.white,
                  ),
                  PieChartIndicator(
                    color: AppColors.secondPieChartColor,
                    label: 'blocked',
                    count: emailsBlocked,
                    textColor: Colors.white,
                  ),
                  PieChartIndicator(
                    color: AppColors.fourthPieChartColor,
                    label: 'replied',
                    count: emailsReplied,
                    textColor: Colors.white,
                  ),
                  PieChartIndicator(
                    color: AppColors.thirdPieChartColor,
                    label: 'sent',
                    count: emailsSent,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                sections: isPieChartEmpty()
                    ? [
                        PieChartSectionData(
                          showTitle: false,
                          radius: _pieChartSectionRadius,
                          color: Colors.white54,
                          value: 1,
                        ),
                      ]
                    : [
                        PieChartSectionData(
                          showTitle: false,
                          radius: _pieChartSectionRadius,
                          color: AppColors.firstPieChartColor,
                          value: emailsForwarded.toDouble(),
                        ),
                        PieChartSectionData(
                          showTitle: false,
                          radius: _pieChartSectionRadius,
                          color: AppColors.secondPieChartColor,
                          value: emailsBlocked.toDouble(),
                        ),
                        PieChartSectionData(
                          showTitle: false,
                          radius: _pieChartSectionRadius,
                          color: AppColors.thirdPieChartColor,
                          value: emailsSent.toDouble(),
                        ),
                        PieChartSectionData(
                          showTitle: false,
                          radius: _pieChartSectionRadius,
                          color: AppColors.fourthPieChartColor,
                          value: emailsReplied.toDouble(),
                        ),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
