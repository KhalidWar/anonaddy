import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/domains/presentation/components/add_new_domain.dart';
import 'package:anonaddy/features/domains/presentation/components/domain_list_tile.dart';
import 'package:anonaddy/features/domains/presentation/components/empty_domain_tile.dart';
import 'package:anonaddy/features/domains/presentation/controller/domains_tab_notifier.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainsTab extends ConsumerStatefulWidget {
  const DomainsTab({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _DomainsTabState();
}

class _DomainsTabState extends ConsumerState<DomainsTab> {
  void addNewDomain(BuildContext context) {
    final accountState = ref.read(accountNotifierProvider).value!;

    /// Draws UI for adding new recipient
    Future buildAddNewDomain(BuildContext context) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.kBottomSheetBorderRadius),
          ),
        ),
        builder: (context) => const AddNewDomain(),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// Fetch domains from server
      ref.watch(domainsNotifierProvider.notifier).fetchDomains();
    });
  }

  @override
  Widget build(BuildContext context) {
    final domainsAsync = ref.watch(domainsNotifierProvider);

    return domainsAsync.when(
      data: (domains) {
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            domains.isEmpty
                ? const EmptyDomainTile()
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
        return const RecipientsShimmerLoading();
      },
    );
  }
}
