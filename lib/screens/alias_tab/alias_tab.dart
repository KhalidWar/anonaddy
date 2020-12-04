import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/widgets/account_card.dart';
import 'package:anonaddy/widgets/alias_card.dart';
import 'package:anonaddy/widgets/create_new_alias.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:anonaddy/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error_screen.dart';

class AliasTab extends StatefulWidget {
  @override
  _AliasTabState createState() => _AliasTabState();
}

class _AliasTabState extends State<AliasTab> {
  Stream<UserModel> _userDataStream;

  @override
  void initState() {
    super.initState();
    _userDataStream = context.read(apiServiceProvider).getUserDataStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserModel>(
        stream: _userDataStream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return ErrorScreen(
                label: 'No Internet Connection.\nMake sure you\'re online.',
                buttonLabel: 'Reload',
                buttonOnPress: () =>
                    context.refresh(apiServiceProvider).getUserDataStream(),
              );
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
                return Scaffold(
                  floatingActionButton: buildFloatingActionButton(context),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        AccountCard(userData: snapshot.data),
                        AliasCard(aliasDataList: snapshot.data.aliasDataList),
                      ],
                    ),
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
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return CreateNewAlias();
            });
      },
    );
  }
}
