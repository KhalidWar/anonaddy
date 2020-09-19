import 'package:anonaddy/constants.dart';
import 'package:anonaddy/provider/api_data_manager.dart';
import 'package:anonaddy/screens/profile_screen.dart';
import 'package:anonaddy/screens/settings_screen.dart';
import 'package:anonaddy/widgets/account_card.dart';
import 'package:anonaddy/widgets/alias_card.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:anonaddy/widgets/create_alias_dialog.dart';
import 'package:anonaddy/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
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
        floatingActionButton: buildFloatingActionButton(),
        body: RefreshIndicator(
          onRefresh: apiDataManager.fetchData,
          child: FutureBuilder(
            future: apiDataManager.fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Consumer<APIDataManager>(
                  builder: (_, _apiDataManager, ___) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Column(
                          children: [
                            AccountCard(
                              username: apiDataManager.username,
                              id: apiDataManager.id,
                              subscription: apiDataManager.subscription,
                              bandwidth: apiDataManager.bandwidth,
                              bandwidthLimit: apiDataManager.bandwidthLimit,
                            ),
                            AliasCard(
                              aliasCount: apiDataManager.aliasCount,
                              aliasLimit: apiDataManager.aliasLimit,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: apiDataManager.aliasList.length,
                                itemBuilder: (context, index) {
                                  return AliasListTile(
                                    index: index,
                                    apiDataManager: apiDataManager,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
      // title: Image.asset('assets/images/logo-dark.svg'),
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

  FloatingActionButton buildFloatingActionButton() {
    String textFieldInput;
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
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
                  APIDataManager().createNewAlias(description: textFieldInput);
                  Navigator.pop(context);
                },
              );
            });
      },
    );
  }
}
