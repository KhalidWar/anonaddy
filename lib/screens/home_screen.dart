import 'package:anonaddy/constants.dart';
import 'package:anonaddy/provider/api_data_manager.dart';
import 'package:anonaddy/screens/profile_screen.dart';
import 'package:anonaddy/screens/settings_screen.dart';
import 'package:anonaddy/widgets/account_card.dart';
import 'package:anonaddy/widgets/alias_card.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:anonaddy/widgets/create_alias_dialog.dart';
import 'package:anonaddy/widgets/loading_widget.dart';
import 'package:anonaddy/widgets/manage_alias_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final apiDataManager = Provider.of<APIDataManager>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundColor,
        appBar: buildAppBar(),
        floatingActionButton:
            buildFloatingActionButton(context, apiDataManager),
        body: RefreshIndicator(
          onRefresh: apiDataManager.fetchData,
          child: FutureBuilder(
            future: apiDataManager.fetchData(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Consumer<APIDataManager>(
                  builder: (_, _apiDataManager, ___) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(5),
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          AccountCard(
                            username: _apiDataManager.username,
                            id: _apiDataManager.id,
                            subscription: _apiDataManager.subscription,
                            bandwidth: _apiDataManager.bandwidth,
                            bandwidthLimit: _apiDataManager.bandwidthLimit,
                            aliasCount: _apiDataManager.aliasCount,
                            aliasLimit: _apiDataManager.aliasLimit,
                            apiDataManager: _apiDataManager,
                            itemCount: _apiDataManager.aliasList.length,
                          ),
                          AliasCard(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _apiDataManager.aliasList.length,
                              itemBuilder: (context, index) {
                                var data = _apiDataManager.aliasList[index];
                                return AliasListTile(
                                  email: data.email,
                                  emailDescription: data.emailDescription,
                                  switchValue: data.isAliasActive,
                                  listTileOnPress: () {},
                                  switchOnPress: (toggle) {
                                    if (data.isAliasActive == true) {
                                      _apiDataManager.deactivateAlias(
                                          aliasID: data.aliasID);
                                      data.isAliasActive = false;
                                    } else {
                                      _apiDataManager.activateAlias(
                                        aliasID: data.aliasID,
                                      );
                                      data.isAliasActive = true;
                                    }
                                  },
                                  child: ManageAliasDialog(
                                    title: data.email,
                                    emailDescription: data.emailDescription,
                                    deleteOnPress: () {
                                      setState(() {
                                        _apiDataManager.deleteAlias(
                                            aliasID: data.aliasID);
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return LoadingWidget();
              }
            },
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

  FloatingActionButton buildFloatingActionButton(
      BuildContext context, APIDataManager apiDataManager) {
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
                    apiDataManager.createNewAlias(description: textFieldInput);
                    Navigator.pop(context);
                  });
                },
              );
            });
      },
    );
  }
}
