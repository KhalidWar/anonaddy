import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/screens/account_tab/usernames/username_detailed_screen.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdditionalUsername extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final account = watch(accountStreamProvider).data;
    if (account == null) {
      return LottieWidget(
        lottie: 'assets/lottie/errorCone.json',
        lottieHeight: MediaQuery.of(context).size.height * 0.2,
        label: kLoadAccountDataFailed,
      );
    }

    if (account.value.account.subscription == kFreeSubscription) {
      return Center(
        child: Text(
          kOnlyAvailableToPaid,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    } else {
      final usernameStream = watch(usernamesProvider);

      return usernameStream.when(
        loading: () => RecipientsShimmerLoading(),
        data: (usernameData) {
          final usernamesList = usernameData.usernames;
          if (usernamesList.isEmpty) {
            return Center(
              child: Text(
                'No additional usernames found',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          } else {
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
                    Navigator.push(
                      context,
                      CustomPageRoute(
                          UsernameDetailedScreen(username: username)),
                    );
                  },
                );
              },
            );
          }
        },
        error: (error, stackTrace) {
          return LottieWidget(
            lottie: 'assets/lottie/errorCone.json',
            lottieHeight: MediaQuery.of(context).size.height * 0.1,
            label: error.toString(),
          );
        },
      );
    }
  }
}
