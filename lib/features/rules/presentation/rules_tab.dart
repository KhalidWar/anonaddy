import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/rules/presentation/components/add_new_rule.dart';
import 'package:anonaddy/features/rules/presentation/components/add_new_rule_enter_name.dart';
import 'package:anonaddy/features/rules/presentation/components/rules_list_tile.dart';
import 'package:anonaddy/features/rules/presentation/controller/create_new_rule_notifier.dart';
import 'package:anonaddy/features/rules/presentation/controller/rules_tab_notifier.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
                onPress: () =>
                    pageIndexNotifier.value = pageIndexNotifier.value + 1,
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
                                onPress: () => pageIndexNotifier.value =
                                    pageIndexNotifier.value + 1,
                              ),
                            ),
                            Utilities.buildWoltModalSheetSubPage(
                              context,
                              showLeading: true,
                              pageTitle:
                                  'Provide a unique memorable description',
                              topBarTitle: AppStrings.addNewRule,
                              leadingWidgetOnPress: () => pageIndexNotifier
                                  .value = pageIndexNotifier.value - 1,
                              child: AddNewRuleEnterName(
                                ruleId: rules[index].id,
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
                          ];
                        },
                      );
                    },
                  );
                },
              ),
            TextButton(
              child: const Text(AppStrings.addNewRule),
              onPressed: () => createNewRule(context, rules.first.id),
            ),
          ],
        );
      },
      loading: () => const RecipientsShimmerLoading(),
      error: (error, _) => ErrorMessageWidget(message: error.toString()),
    );
  }
}
