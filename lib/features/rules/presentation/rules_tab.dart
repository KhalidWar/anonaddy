import 'package:anonaddy/common/constants/anonaddy_string.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/shimmer_effects/shimmering_list_tile.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/rules/presentation/components/add_new_rule.dart';
import 'package:anonaddy/features/rules/presentation/components/add_new_rule_condition.dart';
import 'package:anonaddy/features/rules/presentation/components/add_new_rule_enter_name.dart';
import 'package:anonaddy/features/rules/presentation/components/rules_list_tile.dart';
import 'package:anonaddy/features/rules/presentation/controller/create_new_rule_notifier.dart';
import 'package:anonaddy/features/rules/presentation/controller/rules_tab_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@RoutePage(name: 'RulesTabRoute')
class RulesTab extends ConsumerStatefulWidget {
  const RulesTab({super.key});

  @override
  ConsumerState createState() => _RulesTabState();
}

class _RulesTabState extends ConsumerState<RulesTab> {
  final pageIndexNotifier = ValueNotifier(0);

  void resetPageIndex() {
    pageIndexNotifier.value = 0;
  }

  void createNewRule(BuildContext context, String ruleId) {
    final accountState = ref.read(accountNotifierProvider).value;
    if (accountState == null) return;

    /// Draws UI for adding new recipient
    Future<void> buildAddNewRecipient() async {
      await WoltModalSheet.show(
        context: context,
        pageListBuilder: (context) {
          return [
            Utilities.buildWoltModalSheetSubPage(
              context,
              topBarTitle: AppStrings.addNewRule,
              pageTitle: AddyString.addNewRuleString,
              child: AddNewRule(
                ruleId: ruleId,
                ruleNameOnPress: () {},
                conditionTileOnPress: () {},
              ),
            ),
          ];
        },
      );
    }

    if (accountState.isSelfHosted) {
      buildAddNewRecipient();
    } else {
      accountState.hasReachedRulesLimit
          ? Utilities.showToast(AddyString.reachedRulesLimit)
          : buildAddNewRecipient();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rulesTabNotifierProvider.notifier).fetchRules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rulesState = ref.watch(rulesTabNotifierProvider);

    return rulesState.when(
      data: (rules) {
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            if (rules.isEmpty)
              const ListTile(
                title: Center(
                  child: Text(AppStrings.noRulesFound),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: rules.length,
                itemBuilder: (context, index) {
                  final rule = rules[index];
                  return RulesListTile(
                    rule: rule,
                    onTap: () async {
                      await WoltModalSheet.show(
                        context: context,
                        onModalDismissedWithDrag: resetPageIndex,
                        onModalDismissedWithBarrierTap: () {
                          Navigator.of(context).pop();
                          resetPageIndex();
                        },
                        pageIndexNotifier: pageIndexNotifier,
                        pageListBuilder: (context) {
                          return [
                            Utilities.buildWoltModalSheetSubPage(
                              context,
                              topBarTitle: AppStrings.addNewRule,
                              pageTitle: AddyString.addNewRuleString,
                              child: AddNewRule(
                                ruleId: rule.id,
                                ruleNameOnPress: () =>
                                    Utilities.showToast(AppStrings.comingSoon),
                                conditionTileOnPress: () =>
                                    Utilities.showToast(AppStrings.comingSoon),
                              ),
                            ),
                            Utilities.buildWoltModalSheetSubPage(
                              context,
                              showLeading: true,
                              pageTitle:
                                  'Provide a unique memorable description',
                              topBarTitle: AppStrings.addNewRule,
                              leadingWidgetOnPress: resetPageIndex,
                              child: AddNewRuleEnterName(
                                ruleId: rule.id,
                                onPress: (name) async {
                                  await ref
                                      .read(
                                          createNewRuleNotifierProvider(rule.id)
                                              .notifier)
                                      .updateRuleName(name);
                                  resetPageIndex();
                                },
                              ),
                            ),
                            Utilities.buildWoltModalSheetSubPage(
                              context,
                              showLeading: true,
                              topBarTitle: 'Add condition',
                              leadingWidgetOnPress: resetPageIndex,
                              child: AddNewRuleCondition(
                                ruleId: rule.id,
                                onPress: () =>
                                    Utilities.showToast(AppStrings.comingSoon),
                              ),
                            ),
                          ];
                        },
                      );
                    },
                  );
                },
              ),
            TextButton(
              child: const Text(AppStrings.addNewRule),
              onPressed: () => Utilities.showToast(AppStrings.comingSoon),
              // onPressed: () => createNewRule(context, rules.first.id),
            ),
          ],
        );
      },
      loading: () => const ShimmeringListTile(),
      error: (error, _) => ErrorMessageWidget(message: error.toString()),
    );
  }
}
