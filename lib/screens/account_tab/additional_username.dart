import 'package:anonaddy/screens/account_tab/username_detailed_screen.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
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
    if (account.value.subscription == 'free') {
      return Center(
        child: Text(
          kOnlyAvailableToPaid,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    } else {
      final usernameStream = watch(usernamesProvider);
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return usernameStream.when(
        loading: () => RecipientsShimmerLoading(),
        data: (usernameData) {
          final usernameList = usernameData.usernameDataList;
          if (usernameList.isEmpty)
            return Center(
              child: Text(
                'No additional usernames found',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          else
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 0),
              itemCount: usernameList.length,
              itemBuilder: (context, index) {
                final username = usernameList[index];
                return InkWell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: isDark ? Colors.white : Colors.grey,
                          size: 30,
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username.username),
                            SizedBox(height: 2),
                            Text(
                              username.description ?? 'No description',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    context.read(usernameStateManagerProvider).usernameModel =
                        username;
                    Navigator.push(
                      context,
                      CustomPageRoute(UsernameDetailedScreen()),
                    );
                  },
                );
              },
            );
        },
        error: (error, stackTrace) {
          return LottieWidget(
            lottie: 'assets/lottie/errorCone.json',
            lottieHeight: MediaQuery.of(context).size.height * 0.1,
            label: '$error',
          );
        },
      );
    }
  }
}
