import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/widgets/account_card.dart';
import 'package:anonaddy/widgets/alias_card.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:anonaddy/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error_screen.dart';

class AccountTab extends StatefulWidget {
  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  Stream<UserModel> userDataStream;

  @override
  void initState() {
    super.initState();
    userDataStream = context.read(apiServiceProvider).getUserDataStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: userDataStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return ErrorScreen(
                label: 'No Internet Connection.\nMake sure you\'re online.',
                buttonLabel: 'Reload',
                buttonOnPress: () {});
            break;
          case ConnectionState.waiting:
            return FetchingDataIndicator();
          default:
            if (snapshot.hasData) {
              for (var item in snapshot.data.aliasDataList) {
                UserModel(
                  aliasDataList: [
                    AliasDataModel(
                      aliasID: item.aliasID,
                      email: item.email,
                      emailDescription: item.emailDescription,
                      createdAt: item.createdAt,
                      isAliasActive: item.isAliasActive,
                    ),
                  ],
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    AccountCard(userData: snapshot.data),
                    AliasCard(aliasDataList: snapshot.data.aliasDataList),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return ErrorScreen(
                  label: '${snapshot.error}',
                  buttonLabel: 'Sign In',
                  buttonOnPress: () {});
            } else {
              return LoadingWidget();
            }
        }
      },
    );
  }
}
