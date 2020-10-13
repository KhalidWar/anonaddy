import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/screens/profile_screen.dart';
import 'package:anonaddy/screens/settings_screen.dart';
import 'package:anonaddy/services/api_data_manager.dart';
import 'package:anonaddy/widgets/account_card.dart';
import 'package:anonaddy/widgets/alias_card.dart';
import 'package:anonaddy/widgets/domain_format_widget.dart';
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
  final APIDataManager _apiDataManager = APIDataManager();
  Future<UserModel> _futureUserModel;
  Future<AliasModel> _futureAliasModel;

  Future _refreshData() async {
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
    _futureUserModel = _apiDataManager.fetchUserData();
    _futureAliasModel = _apiDataManager.fetchAliasData();
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
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  FutureBuilder<UserModel>(
                    future: _futureUserModel,
                    builder: (context, snapshot) {
                      var data = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return AccountCard(userData: data);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  FutureBuilder<AliasModel>(
                    future: _futureAliasModel,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          var data = snapshot.data.aliasDataList;

                          for (var item in data) {
                            AliasModel(
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

                          return AliasCard(
                            apiDataManager: _apiDataManager,
                            aliasDataList: data,
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
