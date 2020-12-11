import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/widgets/account_card.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}
