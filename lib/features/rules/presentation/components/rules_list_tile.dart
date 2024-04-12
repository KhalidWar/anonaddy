import 'package:anonaddy/features/rules/domain/rule.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';

class RulesListTile extends StatelessWidget {
  const RulesListTile({
    super.key,
    required this.rule,
    required this.onTap,
  });

  final Rule rule;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final conditionsLength = rule.conditions.length;
    final actionsLength = rule.actions.length;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: RadialGradient(
                  radius: 0.7,
                  stops: const [0.15, 1.0],
                  colors: rule.active
                      ? const [Color(0xff31b237), Colors.white]
                      : const [Colors.grey, Colors.white],
                ),
              ),
              child: Center(
                child: Text(
                  (rule.order + 1).toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rule.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$conditionsLength ${Utilities.pluralize(conditionsLength, 'condition')}, $actionsLength ${Utilities.pluralize(actionsLength, 'action')}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
