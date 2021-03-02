import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey : Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (_, __) {
          return ListTile(
            dense: true,
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            leading: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            title: Container(
              width: 50,
              height: 10.0,
              color: Colors.white,
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Container(
                    width: 20,
                    height: 10.0,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                ),
              ],
            ),
            trailing: Container(
              width: 20.0,
              height: 25.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          );
        },
      ),
    );
  }
}
