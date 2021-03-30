import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/screens/account_tab/username_detailed_screen.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/custom_page_route.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:anonaddy/widgets/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final additionalUsernameStreamProvider =
    FutureProvider.autoDispose<UsernameModel>((ref) {
  final offlineData = ref.read(offlineDataProvider);
  return ref.read(usernameServiceProvider).getUsernameData(offlineData);
});

class AdditionalUsername extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final usernameStream = watch(additionalUsernameStreamProvider);

    return usernameStream.when(
      loading: () => RecipientsShimmerLoading(),
      data: (usernameData) {
        final usernameList = usernameData.usernameDataList;
        if (usernameList.isEmpty)
          return Center(
            child: Text('No additional usernames found',
                style: Theme.of(context).textTheme.bodyText1),
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  Navigator.push(
                    context,
                    CustomPageRoute(UsernameDetailedScreen(username: username)),
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
