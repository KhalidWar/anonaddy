import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/screens/account_tab/components/paid_feature_wall.dart';
import 'package:anonaddy/screens/account_tab/usernames/username_detailed_screen.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:anonaddy/state_management/usernames/usernames_notifier.dart';
import 'package:anonaddy/state_management/usernames/usernames_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdditionalUsername extends ConsumerWidget {
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

        final usernameState = watch(usernameStateNotifier);
        switch (usernameState.status) {
          case UsernamesStatus.loading:
            return RecipientsShimmerLoading();

          case UsernamesStatus.loaded:
            final usernames = usernameState.usernameModel!.usernames;
            if (usernames.isEmpty) {
              return Center(
                child: Text(
                  'No additional usernames found',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            }

            return usernamesList(usernames);

          case UsernamesStatus.failed:
            final error = usernameState.errorMessage;
            return LottieWidget(
              lottie: 'assets/lottie/errorCone.json',
              lottieHeight: MediaQuery.of(context).size.height * 0.1,
              label: error.toString(),
            );
        }

      case AccountStatus.failed:
        return LottieWidget(
          lottie: 'assets/lottie/errorCone.json',
          lottieHeight: MediaQuery.of(context).size.height * 0.2,
          label: kLoadAccountDataFailed,
        );
    }
  }

  ListView usernamesList(List<Username> usernamesList) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 0),
      itemCount: usernamesList.length,
      itemBuilder: (context, index) {
        final username = usernamesList[index];
        return InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.account_circle_outlined),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username.username),
                    SizedBox(height: 2),
                    Text(
                      username.description ?? kNoDescription,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              UsernameDetailedScreen.routeName,
              arguments: username,
            );
          },
        );
      },
    );
  }
}
