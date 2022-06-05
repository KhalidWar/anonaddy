import 'package:anonaddy/screens/account_tab/domains/components/add_new_domain.dart';
import 'package:anonaddy/screens/account_tab/domains/components/domain_list_tile.dart';
import 'package:anonaddy/screens/account_tab/domains/components/empty_domain_tile.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/state_management/domains/domains_tab_notifier.dart';
import 'package:anonaddy/state_management/domains/domains_tab_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainsTab extends ConsumerStatefulWidget {
  const DomainsTab({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _DomainsTabState();
}

class _DomainsTabState extends ConsumerState<DomainsTab> {
  void addNewDomain(BuildContext context) {
    final accountState = ref.read(accountStateNotifier);

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
          ? NicheMethod.showToast(AnonAddyString.reachedDomainLimit)
          : buildAddNewDomain(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// Fetch offline state initially
      ref.watch(domainsStateNotifier.notifier).loadOfflineState();

      /// Fetch domains from server
      ref.watch(domainsStateNotifier.notifier).fetchDomains();
    });
  }

  @override
  Widget build(BuildContext context) {
    final domainsState = ref.watch(domainsStateNotifier);

    switch (domainsState.status) {
      case DomainsTabStatus.loading:
        return const RecipientsShimmerLoading();

      case DomainsTabStatus.loaded:
        final domains = domainsState.domains;

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

      case DomainsTabStatus.failed:
        final error = domainsState.errorMessage;
        return LottieWidget(
          lottie: LottieImages.errorCone,
          lottieHeight: MediaQuery.of(context).size.height * 0.1,
          label: error.toString(),
        );
    }
  }
}
