import 'package:anonaddy/features/rules/domain/rule_action.dart';
import 'package:flutter/material.dart';

class RuleActionListTile extends StatelessWidget {
  const RuleActionListTile({
    super.key,
    required this.action,
    required this.isFirst,
    required this.onPress,
  });

  final RuleAction action;
  final bool isFirst;
  final Function() onPress;

  Widget buildChip(BuildContext context, String value) {
    return Chip(
      label: Text(value),
      visualDensity: VisualDensity.compact,
      backgroundColor: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget buildValue(BuildContext context) {
    switch ((action.runtimeType)) {
      case RuleActionSubject:
        final subject = action as RuleActionSubject;
        return buildChip(context, subject.value);

      case RuleActionDisplayFrom:
        final displayFrom = action as RuleActionDisplayFrom;
        return buildChip(context, displayFrom.value);

      case RuleActionBanner:
        final banner = action as RuleActionBanner;
        return buildChip(context, banner.bannerLocation.value);

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(isFirst ? 'Then ' : 'And then '),
                      Text(
                        '${action.type.value} ',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  buildValue(context),
                ],
              ),
            ),
            // const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
