import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyListAliasTabWidget extends StatelessWidget {
  const EmptyListAliasTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Text(
        'It doesn\'t look like you have any aliases yet!',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDark ? Colors.white : AppColors.primaryColor,
            ),
      ),
    );
  }
}
