import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_list_tile.dart';
import 'package:anonaddy/services/api_service.dart';
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
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
                    AliasesHeader(),
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
                              final aliasDataList = snapshot.data.aliasDataList;
                              List<AliasDataModel> _availableAliasList = [];
                              List<AliasDataModel> _deletedAliasList = [];

                              for (int i = 0; i < aliasDataList.length; i++) {
                                if (aliasDataList[i].deletedAt == null) {
                                  _availableAliasList.add(aliasDataList[i]);
                                } else {
                                  _deletedAliasList.add(aliasDataList[i]);
                                }
                              }

                              return Column(
                                children: [
                                  ExpansionTile(
                                    title: Text('Available Aliases'),
                                    initiallyExpanded: true,
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _availableAliasList.length,
                                        itemBuilder: (context, index) {
                                          return AliasListTile(
                                              aliasModel:
                                                  _availableAliasList[index]);
                                        },
                                      ),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text('Deleted Aliases'),
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
                                                aliasModel:
                                                    _deletedAliasList[index],
                                              );
                                            },
                                          ),
                                          Divider(),
                                          FlatButton(
                                            child: Text('View Full List'),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return DeletedAliasesScreen(
                                                      aliasDataModel:
                                                          _deletedAliasList,
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
