import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/screens/profile_screen.dart';
import 'package:anonaddy/screens/settings_screen.dart';
import 'package:anonaddy/services/api_data_manager.dart';
import 'package:anonaddy/widgets/account_card.dart';
import 'package:anonaddy/widgets/alias_card.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:anonaddy/widgets/create_alias_dialog.dart';
import 'package:anonaddy/widgets/pop_scope_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  APIDataManager _apiDataManager = APIDataManager();
  Future<UserModel> futureUserModel;
  Future<AliasModel> futureAliasModel;

  Future refreshData() async {
    return await _apiDataManager.fetchAliasData();
  }

  Future<bool> _onBackButtonPress() {
    return showDialog(
        context: context,
        builder: (context) {
          return PopScopeDialog();
        });
  }

  @override
  void initState() {
    super.initState();
    futureUserModel = _apiDataManager.fetchUserData();
    futureAliasModel = _apiDataManager.fetchAliasData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundColor,
        appBar: buildAppBar(),
        floatingActionButton: buildFloatingActionButton(context),
        body: WillPopScope(
          onWillPop: _onBackButtonPress,
          child: RefreshIndicator(
            onRefresh: refreshData,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  FutureBuilder<UserModel>(
                    future: futureUserModel,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          // print(snapshot.data.username);
                          return AccountCard(
                            username: snapshot.data.username,
                            id: snapshot.data.id,
                            subscription: snapshot.data.subscription,
                            bandwidth: snapshot.data.bandwidth,
                            bandwidthLimit: snapshot.data.bandwidthLimit,
                            aliasCount: snapshot.data.aliasCount,
                            aliasLimit: snapshot.data.aliasLimit,
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  FutureBuilder<AliasModel>(
                    future: futureAliasModel,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          var data = snapshot.data.aliasDataList;
                          List<AliasModel> aliasModelList = List<AliasModel>();

                          for (int i = 0; i < data.length - 1; i++) {
                            aliasModelList.add(
                              AliasModel(
                                aliasDataList: [
                                  AliasData(
                                    aliasID: data[i].aliasID,
                                    email: data[i].email,
                                    emailDescription: data[i].emailDescription,
                                    createdAt: data[i].createdAt,
                                    isAliasActive: data[i].isAliasActive,
                                  ),
                                ],
                              ),
                            );
                          }

                          return AliasCard(
                            child: ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: aliasModelList
                                  .map(
                                    (aliasModel) => AliasListTile(
                                      aliasModel: aliasModel.aliasDataList[0],
                                      apiDataManager: _apiDataManager,
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kAppBarColor,
      title: SvgPicture.asset(
        'assets/images/logo.svg',
        height: MediaQuery.of(context).size.height * 0.03,
      ),
      centerTitle: true,
      leading: IconButton(
          icon: Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          }),
      actions: [
        IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            }),
      ],
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        String textFieldInput;
        showDialog(
            context: context,
            builder: (context) {
              return CreateAliasDialog(
                format: 'UUID',
                domain: 'anonaddy.me',
                textFieldOnChanged: (input) {
                  textFieldInput = input;
                },
                buttonOnPress: () {
                  setState(() {
                    _apiDataManager.createNewAlias(description: textFieldInput);
                    Navigator.pop(context);
                  });
                },
              );
            });
      },
    );
  }
}
