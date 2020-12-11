import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_list_tile.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:anonaddy/widgets/aliases_header.dart';
import 'package:anonaddy/widgets/create_new_alias.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:anonaddy/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error_screen.dart';
import 'deleted_aliases_screen.dart';

class AliasTab extends StatefulWidget {
  @override
  _AliasTabState createState() => _AliasTabState();
}

class _AliasTabState extends State<AliasTab> {
  final _formKey = GlobalKey<FormState>();
  Stream<AliasModel> _aliasDataStream;

  Stream<AliasModel> getAliasStream() async* {
    yield await context.read(apiServiceProvider).getAllAliasesData();
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield await context.read(apiServiceProvider).getAllAliasesData();
    }
  }

  @override
  void initState() {
    super.initState();
    _aliasDataStream = getAliasStream();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        floatingActionButton: buildFloatingActionButton(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (input) =>
                        FormValidator().searchValidator(input),
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
              ),
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AliasesHeader(),
                    StreamBuilder<AliasModel>(
                      stream: _aliasDataStream,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return ErrorScreen(
                              label:
                                  'No Internet Connection.\nMake sure you\'re online.',
                            );
                          case ConnectionState.waiting:
                            return Padding(
                              padding: EdgeInsets.all(20),
                              child: FetchingDataIndicator(),
                            );
                          default:
                            if (snapshot.hasData) {
                              final aliasDataList = snapshot.data.aliasDataList;
                              final availableAliasList = <AliasDataModel>[];
                              final deletedAliasList = <AliasDataModel>[];
                              final forwardedList = <int>[];
                              final blockedList = <int>[];
                              final repliedList = <int>[];
                              final sentList = <int>[];

                              for (int i = 0; i < aliasDataList.length; i++) {
                                forwardedList
                                    .add(aliasDataList[i].emailsForwarded);
                                blockedList.add(aliasDataList[i].emailsBlocked);
                                repliedList.add(aliasDataList[i].emailsReplied);
                                sentList.add(aliasDataList[i].emailsSent);

                                if (aliasDataList[i].deletedAt == null) {
                                  availableAliasList.add(aliasDataList[i]);
                                } else {
                                  deletedAliasList.add(aliasDataList[i]);
                                }
                              }

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AliasDetailListTile(
                                          title:
                                              '${forwardedList.reduce((value, element) => value + element)}',
                                          titleTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          subtitle: 'Emails Forwarded',
                                          leadingIconData:
                                              Icons.forward_to_inbox,
                                        ),
                                      ),
                                      Expanded(
                                        child: AliasDetailListTile(
                                          title:
                                              '${sentList.reduce((value, element) => value + element)}',
                                          titleTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          subtitle: 'Emails Sent',
                                          leadingIconData:
                                              Icons.mark_email_read_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AliasDetailListTile(
                                          title:
                                              '${repliedList.reduce((value, element) => value + element)}',
                                          titleTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          subtitle: 'Emails Replied',
                                          leadingIconData: Icons.reply,
                                        ),
                                      ),
                                      Expanded(
                                        child: AliasDetailListTile(
                                          title:
                                              '${blockedList.reduce((value, element) => value + element)}',
                                          titleTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          subtitle: 'Emails Blocked',
                                          leadingIconData: Icons.block,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text(
                                      'Available Aliases',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    initiallyExpanded: true,
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: availableAliasList.length,
                                        itemBuilder: (context, index) {
                                          return AliasListTile(
                                              aliasData:
                                                  availableAliasList[index]);
                                        },
                                      ),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text(
                                      'Deleted Aliases',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    children: [
                                      Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: 10,
                                            itemBuilder: (context, index) {
                                              return AliasListTile(
                                                aliasData:
                                                    deletedAliasList[index],
                                              );
                                            },
                                          ),
                                          Divider(),
                                          FlatButton(
                                            child: Text('View full list'),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return DeletedAliasesScreen(
                                                      aliasDataModel:
                                                          deletedAliasList,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
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
