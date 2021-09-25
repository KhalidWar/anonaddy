import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/screens/account_tab/components/paid_feature_wall.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain_detailed_screen.dart';

class Domains extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accountState = watch(accountStateNotifier);

    switch (accountState.status) {
      case AccountStatus.loading:
        return RecipientsShimmerLoading();

      case AccountStatus.loaded:
        final subscription = accountState.accountModel!.account.subscription;
        if (subscription == kFreeSubscription) {
          return PaidFeatureWall();
        }

        final domainData = watch(domainsProvider);
        return domainData.when(
          loading: () => RecipientsShimmerLoading(),
          data: (domainModel) {
            if (domainModel.domains.isEmpty) {
              return Center(
                child: Text(
                  'No domains found',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            } else {
              return domainsList(domainModel);
            }
          },
          error: ((error, stackTrace) {
            return LottieWidget(
              lottie: 'assets/lottie/errorCone.json',
              lottieHeight: MediaQuery.of(context).size.height * 0.1,
              label: error.toString(),
            );
          }),
        );

      case AccountStatus.failed:
        return LottieWidget(
          lottie: 'assets/lottie/errorCone.json',
          lottieHeight: MediaQuery.of(context).size.height * 0.2,
          label: kLoadAccountDataFailed,
        );
    }
  }

  ListView domainsList(DomainModel domainModel) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: domainModel.domains.length,
      itemBuilder: (context, index) {
        final domain = domainModel.domains[index];

        return InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.dns_outlined),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(domain.domain),
                    SizedBox(height: 2),
                    Text(
                      domain.description ?? kNoDescription,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              CustomPageRoute(
                DomainDetailedScreen(domain: domain),
              ),
            );
          },
        );
      },
    );
  }
}
