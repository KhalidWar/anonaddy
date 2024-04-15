import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/features/create_alias/presentation/components/create_alias_error_widget.dart';
import 'package:anonaddy/features/rules/presentation/components/rule_condition_list_tile.dart';
import 'package:anonaddy/features/rules/presentation/controller/create_new_rule_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewRuleCondition extends ConsumerStatefulWidget {
  const AddNewRuleCondition({
    super.key,
    required this.ruleId,
    required this.onPress,
  });

  final String ruleId;
  final Function() onPress;

  @override
  ConsumerState createState() => _AddNewRuleConditionState();
}

class _AddNewRuleConditionState extends ConsumerState<AddNewRuleCondition> {
  @override
  Widget build(BuildContext context) {
    final ruleAsync = ref.watch(createNewRuleNotifierProvider(widget.ruleId));
    final notifier =
        ref.read(createNewRuleNotifierProvider(widget.ruleId).notifier);

    return Consumer(
      builder: (context, ref, _) {
        return ruleAsync.when(
          data: (createRuleState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RuleConditionListTile(
                  condition: createRuleState.rule.conditions.first,
                  onPress: () {},
                ),
              ],
            );
          },
          error: (error, _) =>
              CreateAliasErrorWidget(message: error.toString()),
          loading: () => SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            width: double.infinity,
            child: const Center(
              child: PlatformLoadingIndicator(),
            ),
          ),
        );
      },
    );
  }
}
