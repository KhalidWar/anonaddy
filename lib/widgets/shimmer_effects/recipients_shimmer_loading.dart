import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecipientsShimmerLoading extends StatelessWidget {
  const RecipientsShimmerLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey : Colors.grey[400],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: 12,
        itemBuilder: (_, __) {
          return ListTile(
            dense: true,
            horizontalTitleGap: 8,
            minVerticalPadding: 0,
            contentPadding:
                EdgeInsets.only(left: 16, right: 40, top: 0, bottom: 0),
            leading: Container(
              width: 30.0,
              height: 25.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
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
                  padding: EdgeInsets.only(left: size.width * 0.2),
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
          );
        },
      ),
    );
  }
}
