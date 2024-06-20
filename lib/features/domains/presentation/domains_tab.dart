import 'package:anonaddy/common/constants/anonaddy_string.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/shimmer_effects/shimmering_list_tile.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/domains/presentation/components/add_new_domain.dart';
import 'package:anonaddy/features/domains/presentation/components/domain_list_tile.dart';
import 'package:anonaddy/features/domains/presentation/controller/domains_tab_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@RoutePage(name: 'DomainsTabRoute')
class DomainsTab extends ConsumerWidget {
  const DomainsTab({super.key});

  void addNewDomain(BuildContext context, WidgetRef ref) {
    final accountState = ref.read(accountNotifierProvider).value!;

    /// Draws UI for adding new recipient
    Future buildAddNewDomain(BuildContext context) async {
      await WoltModalSheet.show(
        context: context,
        pageListBuilder: (context) {
          return [
            Utilities.buildWoltModalSheetSubPage(
              context,
              topBarTitle: 'Add Domain',
              pageTitle: AddyString.addNewDomainString,
              child: const AddNewDomain(),
            ),
          ];
        },
      );
    }

    if (accountState.isSelfHosted) {
      buildAddNewDomain(context);
    } else {
      accountState.hasDomainsReachedLimit
          ? Utilities.showToast(AddyString.reachedDomainLimit)
          : buildAddNewDomain(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final domainsAsync = ref.watch(domainsNotifierProvider);

    return domainsAsync.when(
      data: (domains) {
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            domains.isEmpty
                ? const ListTile(
                    title: Center(
                      child: Text(AppStrings.noDomainsFound),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: domains.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final domain = domains[index];
                      return DomainListTile(domain: domain);
                    },
                  ),
            // TextButton(
            //   child: const Text(AppStrings.addNewDomain),
            //   onPressed: () => addNewDomain(context),
            // ),
          ],
        );
      },
      error: (error, stack) {
        return ErrorMessageWidget(message: error.toString());
      },
      loading: () {
        return const ShimmeringListTile();
      },
    );
  }
}
