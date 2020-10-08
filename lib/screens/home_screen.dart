import 'package:anonaddy/models/alias_data.dart';
import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/screens/profile_screen.dart';
import 'package:anonaddy/screens/settings_screen.dart';
import 'package:anonaddy/services/api_data_manager.dart';
import 'package:anonaddy/widgets/account_card.dart';
import 'package:anonaddy/widgets/alias_card.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:anonaddy/widgets/domain_format_widget.dart';
import 'package:anonaddy/widgets/pop_scope_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    return await _apiDataManager
        .fetchUserData()
        .then((value) => _apiDataManager.fetchAliasData());
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                            child: ListView.builder(
                              itemCount: data.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Slidable(
                                  key: Key(data[index].toString()),
                                  actionPane: SlidableStrechActionPane(),
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      color: Colors.red,
                                      iconWidget: Icon(
                                        Icons.delete,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        _apiDataManager.deleteAlias(
                                            aliasID: data[index].aliasID);
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                                'Alias Successfully Deleted!')));
                                      },
                                    ),
                                  ],
                                  child: AliasListTile(
                                    apiDataManager: _apiDataManager,
                                    aliasModel: data[index],
                                  ),
                                );
                              },
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
    Size size = MediaQuery.of(context).size;
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        String textFieldInput;
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setModalState) {
                  return Container(
                    height: size.height * 0.6,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Divider(
                              thickness: 3,
                              color: Colors.grey,
                              indent: size.width * 0.35,
                              endIndent: size.width * 0.35,
                            ),
                            SizedBox(height: size.height * 0.01),
                            TextField(
                              onChanged: (input) {
                                setModalState(() {
                                  textFieldInput = input;
                                });
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                hintText: 'Description (optional)',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            DomainFormatWidget(
                                label: 'Domain:', value: '@anonaddy.me'),
                            SizedBox(height: size.height * 0.03),
                            DomainFormatWidget(label: 'Format:', value: 'UUID'),
                          ],
                        ),
                        // Spacer(),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              'Generate New Alias',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            onPressed: () {
                              _apiDataManager.createNewAlias(
                                  description: textFieldInput);
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            });
      },
    );
  }
}
