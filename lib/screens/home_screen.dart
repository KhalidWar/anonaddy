import 'package:anonaddy/constants.dart';
import 'package:anonaddy/provider/account_data.dart';
import 'package:anonaddy/provider/aliases_data.dart';
import 'package:anonaddy/screens/account_screen.dart';
import 'package:anonaddy/screens/settings_screen.dart';
import 'package:anonaddy/widgets/account_info_card.dart';
import 'package:anonaddy/widgets/aliases_list_tile.dart';
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
        backgroundColor: kBackgroundColor,
        appBar: buildAppBar(),
        floatingActionButton: buildFloatingActionButton(),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: FutureBuilder(
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: accountData.getAccountData(),
                    builder: (context, snapshot) {
                      return Consumer<AccountData>(
                        builder: (context, accountData, child) {
                          return AccountInfoCard(
                            username: accountData.username,
                            id: accountData.id,
                            subscription: accountData.subscription,
                            bandwidth: accountData.bandwidth,
                            bandwidthLimit: accountData.bandwidthLimit,
                          );
                        },
                      );
                    },
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Text(
                            'Aliases'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            height: 25,
                            indent: size.width * 0.3,
                            endIndent: size.width * 0.3,
                            color: kAppBarColor,
                            thickness: 1,
                          ),
                          Container(
                            height: size.height * 0.6,
                            child: FutureBuilder(
                              future: aliasesData.getAliasesDetails(),
                              builder: (context, snapshot) {
                                return Consumer<AliasesData>(
                                  builder: (context, aliasesData, child) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount: aliasesData.aliasList.length,
                                      itemBuilder: (context, index) {
                                        return AliasesListTile(
                                          email: aliasesData
                                              .aliasList[index].email,
                                          emailDescription: aliasesData
                                              .aliasList[index]
                                              .emailDescription,
                                          switchOnPress: (toggle) {},
                                          switchValue: aliasesData
                                              .aliasList[index].isAliasActive,
                                          listTileOnPress: () {},
                                          editOnPress: () {},
                                        );
                                      },
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
                ],
              );
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
    Size size = MediaQuery.of(context).size;
    String descriptionInput;

    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Divider(
                          thickness: 2,
                          color: kAppBarColor,
                          indent: size.width * 0.35,
                          endIndent: size.width * 0.35,
                        ),
                        Text(
                          'Generate Alias',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintText: 'Description (optional)',
                      ),
                      onChanged: (input) {
                        descriptionInput = input;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Domain:',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          'anonaddy.me',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Format:',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          'UUID',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                    RaisedButton(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Generate New Alias',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      onPressed: () {
                        // createNewAlias(description: '$descriptionInput');
                        setState(() {
                          // aliasesCount++;
                        });
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              );
            });
      },
    );
  }
}
