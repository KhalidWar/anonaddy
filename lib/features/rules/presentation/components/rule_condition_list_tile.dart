import 'package:anonaddy/features/rules/domain/rule_condition.dart';
import 'package:flutter/material.dart';

class RuleConditionListTile extends StatelessWidget {
  const RuleConditionListTile({
    super.key,
    required this.condition,
    required this.onPress,
  });

  final RuleCondition condition;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(4),
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
                      const Text('If '),
                      Text(
                        '${condition.type.value} ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${condition.match.value}:',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 4,
                    children: condition.values
                        .map((value) => Chip(
                              label: Text(value),
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.all(0),
                              labelPadding:
                                  // const EdgeInsets.all(0),
                                  const EdgeInsets.symmetric(horizontal: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              backgroundColor: Theme.of(context).cardColor,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
