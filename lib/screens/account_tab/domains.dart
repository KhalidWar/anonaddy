import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/screens/account_tab/main_account_card.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final domainsStreamProvider =
    StreamProvider.autoDispose<DomainModel>((ref) async* {
  yield* Stream.fromFuture(ref.read(domainsServiceProvider).getAllDomains());
});

class Domains extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final domainsStream = watch(domainsStreamProvider);

    final userModel = watch(accountStreamProvider);

    return domainsStream.when(
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
                    'Domain${data.domainDataList.length >= 2 ? 's' : ''}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  userModel.when(
                    loading: () => Container(),
                    data: (data) => Text(
                        '${data.activeDomainCount} / ${data.activeDomainLimit}'),
                    error: (error, stackTrace) => Text(''),
                  ),
                ],
              ),
            ),
            if (data.domainDataList.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                child: Text('No domains found'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.domainDataList.length,
                itemBuilder: (context, index) {
                  final domain = data.domainDataList[index];

                  return InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            // color: isDark ? Colors.white : Colors.grey,
                            size: 30,
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${domain.domain}'),
                              SizedBox(height: 2),
                              Text(
                                '${domain.description}',
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
                            // return UsernameDetailedScreen(username: username);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            SizedBox(height: 10),
          ],
        );
      },
      error: ((error, stackTrace) {
        return LottieWidget(
          lottie: 'assets/lottie/errorCone.json',
          label: '$error',
        );
      }),
    );
  }
}
