import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AliasShimmerLoading extends StatelessWidget {
  const AliasShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey : Colors.grey[400]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: 12,
        itemBuilder: (_, __) {
          return ListTile(
            dense: true,
            horizontalTitleGap: 0,
            contentPadding:
                const EdgeInsets.only(left: 6, right: 18, top: 0, bottom: 0),
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
              margin: const EdgeInsets.only(right: 10),
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
