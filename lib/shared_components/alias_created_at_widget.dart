import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';

class AliasCreatedAtWidget extends StatelessWidget {
  const AliasCreatedAtWidget({
    Key? key,
    required this.label,
    required this.dateTime,
  }) : super(key: key);

  final String label;
  final String dateTime;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            NicheMethod.convertStringToDateTime(dateTime, locale),
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: isDark ? Colors.white70 : Colors.black87),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
