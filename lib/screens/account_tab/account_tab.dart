import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/models/username_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/widgets/account_card.dart';
import 'package:anonaddy/widgets/additional_username_card.dart';
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
  Future<UsernameModel> _usernameDataStream;

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
    _usernameDataStream = context.read(apiServiceProvider).getUsernameData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<UserModel>(
            stream: _userDataStream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return LottieWidget(
                    lottie: 'assets/lottie/errorCone.json',
                    label: kNoInternetConnection,
                  );
                  break;
                case ConnectionState.waiting:
                  return FetchingDataIndicator();
                default:
                  if (snapshot.hasData) {
                    return AccountCard(userData: snapshot.data);
                  } else if (snapshot.hasError) {
                    return LottieWidget(
                      lottie: 'assets/lottie/errorCone.json',
                      label: snapshot.error,
                    );
                  } else {
                    return LottieWidget(
                      lottie: 'assets/lottie/errorCone.json',
                      label: snapshot.error,
                    );
                  }
              }
            },
          ),
          Card(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'Additional Usernames',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(height: 0, color: Colors.black),
                FutureBuilder<UsernameModel>(
                  future: _usernameDataStream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.waiting:
                        return FetchingDataIndicator();
                      default:
                        if (snapshot.hasData) {
                          final usernameList = snapshot.data.usernameDataList;
                          if (usernameList.isEmpty) {
                            return emptyUsernameWidget();
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: usernameList.length,
                            itemBuilder: (context, index) {
                              return AdditionalUsernameCard(
                                username: usernameList[index],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          );
                        } else {
                          return LottieWidget(
                            lottie: 'assets/lottie/errorCone.json',
                            label: snapshot.error,
                          );
                        }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
