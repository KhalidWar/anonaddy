import 'package:anonaddy/constants.dart';
import 'package:anonaddy/provider/account_data.dart';
import 'package:anonaddy/provider/aliases_data.dart';
import 'package:anonaddy/screens/account_screen.dart';
import 'package:anonaddy/screens/settings_screen.dart';
import 'package:anonaddy/widgets/account_info_card.dart';
import 'package:anonaddy/widgets/aliases_list_tile.dart';
import 'package:anonaddy/widgets/create_alias_dialog.dart';
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
    Size size = MediaQuery.of(context).size;

    final accountData = Provider.of<AccountData>(context, listen: false);
    final aliasesData = Provider.of<AliasesData>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundColor,
        appBar: buildAppBar(),
        floatingActionButton: buildFloatingActionButton(),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: accountData.getAccountData(),
                builder: (context, snapshot) {
                  return AccountInfoCard(
                    username: accountData.username,
                    id: accountData.id,
                    subscription: accountData.subscription,
                    bandwidth: accountData.bandwidth,
                    bandwidthLimit: accountData.bandwidthLimit,
                  );
                },
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Aliases'.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Column(
                              children: [
                                Text('Aliases'),
                                Text(
                                    '${accountData.aliasCount} / ${accountData.aliasLimit}'),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: kAppBarColor,
                        ),
                        Container(
                          height: size.height * 0.6,
                          child: FutureBuilder(
                            future: aliasesData.getAliasesDetails(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: aliasesData.aliasList.length,
                                itemBuilder: (context, index) {
                                  return AliasesListTile(
                                    email: aliasesData.aliasList[index].email,
                                    emailDescription: aliasesData
                                        .aliasList[index].emailDescription,
                                    switchOnPress: (toggle) {},
                                    switchValue: aliasesData
                                        .aliasList[index].isAliasActive,
                                    listTileOnPress: () {},
                                    editOnPress: () {},
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                MaterialPageRoute(builder: (context) => AccountScreen()));
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
                  AliasesData().createNewAlias(description: textFieldInput);
                  Navigator.pop(context);
                },
              );
            });
      },
    );
  }
}
