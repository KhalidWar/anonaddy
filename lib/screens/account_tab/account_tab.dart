import 'package:anonaddy/models/user/user_model.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/widgets/account_card.dart';
import 'package:anonaddy/widgets/additional_username_card.dart';
import 'package:anonaddy/widgets/card_header.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class AccountTab extends StatefulWidget {
  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  Stream<UserModel> _userDataStream;
  Future<UsernameModel> _usernameDataFuture;

  Stream<UserModel> getUserStream() async* {
    yield await context.read(apiServiceProvider).getUserData();
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield await context.read(apiServiceProvider).getUserData();
    }
  }

  @override
  void initState() {
    super.initState();
    _userDataStream = getUserStream();
    _usernameDataFuture = context.read(apiServiceProvider).getUsernameData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: _userDataStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return LottieWidget(
              lottie: 'assets/lottie/errorCone.json',
              label: kNoInternetConnection,
            );
          case ConnectionState.waiting:
            return FetchingDataIndicator();
          default:
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    AccountCard(userData: snapshot.data),
                    FutureBuilder<UsernameModel>(
                      future: _usernameDataFuture,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return LottieWidget(
                              lottie: 'assets/lottie/errorCone.json',
                              label: kNoInternetConnection,
                            );
                          case ConnectionState.waiting:
                            return FetchingDataIndicator();
                          default:
                            if (snapshot.hasData) {
                              final usernameList =
                                  snapshot.data.usernameDataList;
                              if (usernameList.isEmpty) {
                                return emptyUsernameWidget();
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: usernameList.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Column(
                                      children: [
                                        CardHeader(
                                            label: 'Additional Username'),
                                        if (usernameList.isEmpty)
                                          Text('No usernames found'),
                                        AdditionalUsernameCard(
                                          username: usernameList[index],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                            if (snapshot.hasError) {
                              return LottieWidget(
                                lottie: 'assets/lottie/errorCone.json',
                                label: snapshot.error,
                              );
                            }
                            return LottieWidget(
                              lottie: 'assets/lottie/errorCone.json',
                              label: snapshot.error,
                            );
                        }
                      },
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return LottieWidget(
                lottie: 'assets/lottie/errorCone.json',
                label: snapshot.error,
              );
            }
            return LottieWidget(
              lottie: 'assets/lottie/errorCone.json',
              label: snapshot.error,
            );
        }
      },
    );
  }

  Widget emptyUsernameWidget() {
    return Center(
      child: Container(
        child: Text(
          'You don\'t have any additional username.',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
