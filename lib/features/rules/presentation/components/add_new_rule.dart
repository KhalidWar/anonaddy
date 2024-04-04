import 'dart:developer';

import 'package:anonaddy/features/create_alias/presentation/components/create_alias_error_widget.dart';
import 'package:anonaddy/features/recipients/presentation/controller/add_recipient_notifier.dart';
import 'package:anonaddy/features/rules/presentation/components/rule_action_list_tile.dart';
import 'package:anonaddy/features/rules/presentation/components/rule_checkbox.dart';
import 'package:anonaddy/features/rules/presentation/components/rule_condition_list_tile.dart';
import 'package:anonaddy/features/rules/presentation/controller/create_new_rule_notifier.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewRule extends ConsumerStatefulWidget {
  const AddNewRule({
    super.key,
    required this.ruleId,
    required this.onPress,
  });

  final String ruleId;
  final Function() onPress;

  @override
  ConsumerState createState() => _AddNewRuleState();
}

class _AddNewRuleState extends ConsumerState<AddNewRule> {
  @override
  Widget build(BuildContext context) {
    final ruleAsync = ref.watch(createNewRuleNotifierProvider(widget.ruleId));
    final notifier =
        ref.read(createNewRuleNotifierProvider(widget.ruleId).notifier);

    return Consumer(
      builder: (context, ref, _) {
        return ruleAsync.when(
          data: (ruleState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  dense: true,
                  title: Text(ruleState.rule.name),
                  subtitle: const Text('Rule Name'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: widget.onPress,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Conditions',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ruleState.rule.conditions.length,
                  itemBuilder: (context, index) {
                    final condition = ruleState.rule.conditions[index];

                    return RuleConditionListTile(
                      condition: condition,
                      onPress: () {
                        log(condition.toString());
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Text(
                      ruleState.rule.operator.name.toUpperCase(),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Actions ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ruleState.rule.actions.length,
                  itemBuilder: (context, index) {
                    final action = ruleState.rule.actions[index];

                    return RuleActionListTile(
                      action: action,
                      isFirst: index == 0,
                      onPress: () {
                        log(action.toString());
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RuleCheckbox(
                        value: ruleState.forwards,
                        title: 'Forward',
                        onChanged: notifier.toggleForwards,
                      ),
                      RuleCheckbox(
                        value: ruleState.replies,
                        title: 'Replies',
                        onChanged: notifier.toggleReplies,
                      ),
                      RuleCheckbox(
                        value: ruleState.sends,
                        title: 'Sends',
                        onChanged: notifier.toggleSends,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: PlatformButton(
                    onPress: () {},
                    child: Consumer(
                      builder: (context, ref, _) {
                        final addRecipientAsync =
                            ref.watch(addRecipientNotifierProvider);

                        return addRecipientAsync.when(
                          data: (data) {
                            return Text(
                              'Add New Rule',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.black),
                            );
                          },
                          error: (err, stack) => const SizedBox.shrink(),
                          loading: () => const PlatformLoadingIndicator(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
          error: (error, _) {
            return CreateAliasErrorWidget(message: error.toString());
          },
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
