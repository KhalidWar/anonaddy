import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_list_tile.dart';
import 'package:anonaddy/services/api_service.dart';
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
  final _textEditingController = TextEditingController();
  Stream<AliasModel> _userDataStream;

  @override
  void initState() {
    super.initState();
    _userDataStream = context.read(apiServiceProvider).getAliasStream();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: buildFloatingActionButton(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: TextFormField(
                validator: (value) =>
                    value.length < 1 ? 'Please Enter Access Token' : null,
                controller: _textEditingController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search aliases, descriptions ...',
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor)),
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
            ),
            Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(
                      'Aliases',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  StreamBuilder<AliasModel>(
                    stream: _userDataStream,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return ErrorScreen(
                            label:
                                'No Internet Connection.\nMake sure you\'re online.',
                            buttonLabel: 'Reload',
                            buttonOnPress: () => context
                                .refresh(apiServiceProvider)
                                .getUserStream(),
                          );
                        case ConnectionState.waiting:
                          return Padding(
                            padding: EdgeInsets.all(20),
                            child: FetchingDataIndicator(),
                          );
                        default:
                          if (snapshot.hasData) {
                            for (var item in snapshot.data.aliasDataList) {
                              AliasModel(aliasDataList: [
                                AliasDataModel(
                                  aliasID: item.aliasID,
                                  email: item.email,
                                  emailDescription: item.emailDescription,
                                  createdAt: item.createdAt,
                                  isAliasActive: item.isAliasActive,
                                ),
                              ]);
                            }

                            return Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.aliasDataList.length,
                                itemBuilder: (context, index) {
                                  return AliasListTile(
                                    aliasModel:
                                        snapshot.data.aliasDataList[index],
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return ErrorScreen(
                              label: '${snapshot.error}',
                              buttonLabel: 'Sign In',
                              buttonOnPress: () {},
                            );
                          } else {
                            return LoadingWidget();
                          }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
          },
        );
      },
    );
  }
}