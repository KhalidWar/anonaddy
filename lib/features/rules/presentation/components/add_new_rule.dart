import 'package:anonaddy/features/create_alias/presentation/components/create_alias_error_widget.dart';
import 'package:anonaddy/features/rules/presentation/components/add_new_rule_section_header.dart';
import 'package:anonaddy/features/rules/presentation/components/rule_action_list_tile.dart';
import 'package:anonaddy/features/rules/presentation/components/rule_checkbox.dart';
import 'package:anonaddy/features/rules/presentation/components/rule_condition_list_tile.dart';
import 'package:anonaddy/features/rules/presentation/controller/create_new_rule_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewRule extends ConsumerStatefulWidget {
  const AddNewRule({
    super.key,
    required this.ruleId,
    required this.ruleNameOnPress,
    required this.conditionTileOnPress,
  });

  final String ruleId;
  final Function() ruleNameOnPress;
  final Function() conditionTileOnPress;

  @override
  ConsumerState createState() => _AddNewRuleState();
}

class _AddNewRuleState extends ConsumerState<AddNewRule> {
  @override
  Widget build(BuildContext context) {
    final ruleAsync = ref.watch(createNewRuleNotifierProvider(widget.ruleId));

    return Consumer(
      builder: (context, ref, _) {
        return ruleAsync.when(
          data: (createRuleState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        createRuleState.ruleName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Text('Rule Name'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const AddNewRuleSectionHeader(title: 'Run Rule on'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RuleCheckbox(
                        value: createRuleState.forwards,
                        title: 'Forward',
                        onChanged: (value) =>
                            Utilities.showToast(AppStrings.comingSoon),
                        // onChanged: notifier.toggleForwards,
                      ),
                      RuleCheckbox(
                        value: createRuleState.replies,
                        title: 'Replies',
                        onChanged: (value) =>
                            Utilities.showToast(AppStrings.comingSoon),
                        // onChanged: notifier.toggleReplies,
                      ),
                      RuleCheckbox(
                        value: createRuleState.sends,
                        title: 'Sends',
                        onChanged: (value) =>
                            Utilities.showToast(AppStrings.comingSoon),
                        // onChanged: notifier.toggleSends,
                      ),
                    ],
                  ),
                  AddNewRuleSectionHeader(
                    title: 'Conditions',
                    onPress: widget.conditionTileOnPress,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: createRuleState.conditions.length,
                    itemBuilder: (context, index) {
                      final condition = createRuleState.conditions[index];
                      return RuleConditionListTile(
                        condition: condition,
                        onPress: widget.conditionTileOnPress,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Text(
                        createRuleState.operator.name.toUpperCase(),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  AddNewRuleSectionHeader(
                    title: 'Actions',
                    onPress: widget.conditionTileOnPress,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: createRuleState.actions.length,
                    itemBuilder: (context, index) {
                      final action = createRuleState.actions[index];
                      return RuleActionListTile(
                        action: action,
                        isFirst: index == 0,
                        onPress: () =>
                            Utilities.showToast(AppStrings.comingSoon),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.all(16),
                  //   child: PlatformButton(
                  //     onPress: () async {
                  //       await ref
                  //           .read(createNewRuleNotifierProvider(widget.ruleId)
                  //               .notifier)
                  //           .updateRule();
                  //       if (mounted) Navigator.of(context).pop();
                  //     },
                  //     child: createRuleState.isLoading
                  //         ? const PlatformLoadingIndicator()
                  //         : Text(
                  //             'Add New Rule',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .labelLarge
                  //                 ?.copyWith(color: Colors.black),
                  //           ),
                  //   ),
                  // ),
                ],
              ),
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
