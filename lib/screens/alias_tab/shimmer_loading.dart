import 'package:anonaddy/widgets/alias_tab_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants.dart';

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: size.height * 0.25,
                snap: true,
                elevation: 0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: AliasTabPieChart(
                      emailsForwarded: 0,
                      emailsBlocked: 0,
                      emailsReplied: 0,
                      emailsSent: 0,
                    ),
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: kAccentColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Available Aliases'),
                          Text('0'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Deleted Aliases'),
                          Text('0'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Shimmer.fromColors(
                baseColor: isDark ? Colors.grey : Colors.grey[400],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: 12,
                  itemBuilder: (_, __) {
                    return ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.only(
                          left: 6, right: 18, top: 0, bottom: 0),
                      leading: Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 50,
                              height: 10.0,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: size.width * 0.1),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 10.0,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: size.width * 0.45),
                          ),
                        ],
                      ),
                      trailing: Container(
                        width: 20.0,
                        height: 25.0,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Shimmer.fromColors(
                baseColor: isDark ? Colors.grey : Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: 12,
                  itemBuilder: (_, __) {
                    return ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.only(
                          left: 6, right: 18, top: 0, bottom: 0),
                      leading: Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 50,
                              height: 10.0,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: size.width * 0.1),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 10.0,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: size.width * 0.45),
                          ),
                        ],
                      ),
                      trailing: Container(
                        width: 20.0,
                        height: 25.0,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
