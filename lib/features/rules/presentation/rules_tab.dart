import 'package:anonaddy/features/rules/presentation/controller/rules_tab_notifier.dart';
import 'package:anonaddy/features/rules/presentation/rules_list_tile.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RulesTab extends ConsumerStatefulWidget {
  const RulesTab({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _RulesTabState();
}

class _RulesTabState extends ConsumerState<RulesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(rulesTabNotifierProvider.notifier).fetchRules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rulesState = ref.watch(rulesTabNotifierProvider);

    return rulesState.when(
      data: (rules) {
        return rules.isEmpty
            ? Center(
                child: Text(
                  AppStrings.noRulesFound,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: rules.length,
                itemBuilder: (context, index) {
                  return RulesListTile(
                    rule: rules[index],
                    onTap: () => Utilities.showToast(AppStrings.comingSoon),
                  );
                },
              );
      },
      error: (error, stack) {
        return ErrorMessageWidget(message: error.toString());
      },
      loading: () {
        return const RecipientsShimmerLoading();
      },
    );
  }
}
