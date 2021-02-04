import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/screens/account_tab/main_account_card.dart';
import 'package:anonaddy/screens/account_tab/username_detailed_screen.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final additionalUsernameStream =
    StreamProvider.autoDispose<UsernameModel>((ref) async* {
  yield* Stream.fromFuture(ref.read(usernameServiceProvider).getUsernameData());
  while (true) {
    await Future.delayed(Duration(seconds: 5));
    yield* Stream.fromFuture(
        ref.read(usernameServiceProvider).getUsernameData());
  }
});

class AdditionalUsername extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(additionalUsernameStream);
    final userModel = watch(mainAccountStream);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return stream.when(
      loading: () => Container(),
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 0),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Additional Username${data.usernameDataList.length >= 2 ? 's' : ''}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  userModel.when(
                    loading: () => Container(),
                    data: (data) => Text(
                        '${data.usernameCount} / ${NicheMethod().isUnlimited(data.usernameLimit, '')}'),
                    error: (error, stackTrace) => Text('Error'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            if (data.usernameDataList.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                child: Text('No additional usernames found'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.usernameDataList.length,
                itemBuilder: (context, index) {
                  final username = data.usernameDataList[index];

                  return InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                              Text('${data.usernameDataList[index].username}'),
                              SizedBox(height: 2),
                              Text(
                                '${data.usernameDataList[index].description}',
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
                        PageRouteBuilder(
                          transitionsBuilder:
                              (context, animation, secondAnimation, child) {
                            animation = CurvedAnimation(
                                parent: animation,
                                curve: Curves.linearToEaseOut);

                            return SlideTransition(
                              position: Tween(
                                begin: Offset(1.0, 0.0),
                                end: Offset(0.0, 0.0),
                              ).animate(animation),
                              child: child,
                            );
                          },
                          pageBuilder: (context, animation, secondAnimation) {
                            return UsernameDetailedScreen(username: username);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        );
      },
      error: (error, stackTrace) {
        return LottieWidget(
          lottie: 'assets/lottie/errorCone.json',
          label: '$error',
        );
      },
    );
  }
}
