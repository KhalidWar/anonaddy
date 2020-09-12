import 'package:anonaddy/constants.dart';
import 'package:anonaddy/screens/account_screen.dart';
import 'package:anonaddy/screens/settings_screen.dart';
import 'package:anonaddy/services/networking.dart';
import 'package:anonaddy/widgets/account_info_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, this.accountData, this.aliasesData})
      : super(key: key);

  final accountData;
  final aliasesData;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String baseURL = 'https://app.anonaddy.com/api/v1';
  String aliases = 'aliases';
  String id,
      username,
      subscription,
      lastUpdated,
      email,
      createdAt,
      emailDescription;
  double bandwidth, bandwidthLimit;
  int usernameCount;
  bool isActive;

  void updateUI(dynamic accountData) {
    setState(() {
      id = accountData['data']['id'];
      username = accountData['data']['username'];
      bandwidth = accountData['data']['bandwidth'] / 1024000;
      bandwidthLimit = accountData['data']['bandwidth_limit'] / 1024000;
      usernameCount = accountData['data']['username_count'];
      subscription = accountData['data']['subscription'];
      lastUpdated = accountData['data']['updated_at'];
    });
  }

  Future createNewAlias({String description}) async {
    Networking networking = Networking('$baseURL/$aliases');
    var data = await networking.postData(description: description);
    return data;
  }

  @override
  void initState() {
    super.initState();
    updateUI(widget.accountData);
    print(widget.aliasesData['data'].length);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: buildAppBar(),
        floatingActionButton: buildFloatingActionButton(),
        body: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccountInfoCard(
                username: username,
                id: id,
                subscription: subscription,
                bandwidth: bandwidth,
                bandwidthLimit: bandwidthLimit,
              ),
              SizedBox(height: size.height * 0.01),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Aliases'.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        height: 25,
                        indent: size.width * 0.3,
                        endIndent: size.width * 0.3,
                        color: kAppBarColor,
                        thickness: 1,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.aliasesData['data'].length,
                          itemBuilder: (context, index) {
                            email = widget.aliasesData['data'][index]['email'];
                            createdAt =
                                widget.aliasesData['data'][index]['created_at'];
                            isActive =
                                widget.aliasesData['data'][index]['active'];
                            emailDescription = widget.aliasesData['data'][index]
                                ['description'];
                            return Column(
                              children: [
                                ListTile(
                                  dense: true,
                                  title: Text('$email'),
                                  subtitle: Text('$emailDescription'),
                                  leading: Icon(
                                    isActive ? Icons.check : Icons.block,
                                    color: isActive ? Colors.green : Colors.red,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {},
                                  ),
                                  onTap: () {
                                    //todo copy email to clipboard onTap
                                  },
                                ),
                                Divider(
                                  thickness: 2,
                                  indent: size.width * 0.1,
                                  endIndent: size.width * 0.1,
                                ),
                              ],
                            );
                          }),
                    ],
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
                        createNewAlias(description: '$descriptionInput');
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
