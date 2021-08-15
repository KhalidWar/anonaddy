import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain_detailed_screen.dart';

class Domains extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final account = watch(accountStreamProvider).data;
    if (account == null) {
      return LottieWidget(
        lottie: 'assets/lottie/errorCone.json',
        lottieHeight: MediaQuery.of(context).size.height * 0.2,
        label: kLoadAccountDataFailed,
      );
    } else {
      if (account.value.account.subscription == kFreeSubscription) {
        return Center(
          child: Text(
            account.value.account.subscription == kFreeSubscription
                ? kOnlyAvailableToPaid
                : kComingSoon,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        );
      } else {
        final domainData = watch(domainsProvider);
        return domainData.when(
          loading: () => RecipientsShimmerLoading(),
          data: (domainModel) {
            if (domainModel.domains.isEmpty)
              return Center(
                child: Text(
                  'No domains found',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            else
              return ListView.builder(
                shrinkWrap: true,
                itemCount: domainModel.domains.length,
                itemBuilder: (context, index) {
                  final domain = domainModel.domains[index];

                  return InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.language,
                            // Icons.dns,
                            size: 30,
                          ),
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
                      final domainStateManager =
                          context.read(domainStateManagerProvider);

                      domainStateManager.domain = domain;
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
          },
          error: ((error, stackTrace) {
            return LottieWidget(
              lottie: 'assets/lottie/errorCone.json',
              lottieHeight: MediaQuery.of(context).size.height * 0.1,
              label: error.toString(),
            );
          }),
        );
      }
    }
  }
}
