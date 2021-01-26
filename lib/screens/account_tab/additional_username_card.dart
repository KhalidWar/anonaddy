import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/screens/account_tab/username_detailed_screen.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/loading_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final additionalUsernameStream =
    StreamProvider.autoDispose<UsernameModel>((ref) async* {
  yield* Stream.fromFuture(ref.read(usernameServiceProvider).getUsernameData());
  while (true) {
    await Future.delayed(Duration(seconds: 10));
    yield* Stream.fromFuture(
        ref.read(usernameServiceProvider).getUsernameData());
  }
});

class AdditionalUsernameCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(additionalUsernameStream);

    return stream.when(
      loading: () => LoadingIndicator(),
      data: (data) {
        if (data.usernameDataList.isEmpty) {
          return Column(
            children: [
              Divider(height: 0),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'Additional Username${data.usernameDataList.length >= 2 ? 's' : ''}',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 10),
              Text('No additional usernames found'),
            ],
          );
        }
        return Column(
          children: [
            Divider(height: 0),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Additional Username${data.usernameDataList.length >= 2 ? 's' : ''}',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.usernameDataList.length,
              itemBuilder: (context, index) {
                final username = data.usernameDataList[index];
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.account_circle_outlined),
                  title: Text('${data.usernameDataList[index].username}'),
                  subtitle: Text('${data.usernameDataList[index].description}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionsBuilder:
                            (context, animation, secondAnimation, child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.linearToEaseOut);

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

  PageRouteBuilder buildPageRouteBuilder(Widget child) {
    return PageRouteBuilder(
      transitionsBuilder: (context, animation, secondAnimation, child) {
        animation =
            CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut);

        return SlideTransition(
          position: Tween(
            begin: Offset(1.0, 0.0),
            end: Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondAnimation) {
        return child;
      },
    );
  }
}
