import 'package:anonaddy/constants.dart';
import 'package:anonaddy/screens/account_screen.dart';
import 'package:anonaddy/screens/settings_screen.dart';
import 'package:anonaddy/services/networking.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String baseURL = 'https://app.anonaddy.com/api/v1';
  String accountDetailsURL = 'account-details';
  String aliases = 'aliases';
  String id, username, subscription, lastUpdated;
  double bandwidth, bandwidthLimit;
  int usernameCount;

  Future getAccountDetails() async {
    Networking networking = Networking('$baseURL/$accountDetailsURL');
    var data = await networking.getData();
    print(data);

    setState(() {
      id = data['data']['id'];
      username = data['data']['username'];
      bandwidth = data['data']['bandwidth'] / 1024000;
      bandwidthLimit = data['data']['bandwidth_limit'] / 1024000;
      usernameCount = data['data']['username_count'];
      subscription = data['data']['subscription'];
      lastUpdated = data['data']['updated_at'];
    });
    return data;
  }

  Future createNewAlias({String description}) async {
    Networking networking = Networking('$baseURL/$aliases');
    var data = await networking.postData(description: description);
    return data;
  }

  @override
  void initState() {
    super.initState();
    getAccountDetails();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen()));
                }),
          ],
        ),
        floatingActionButton: buildFloatingActionButton(),
        body: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          '$username'.toUpperCase(),
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
                          thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID:',
                              style: Theme.of(context).textTheme.bodyText1),
                          Text(
                            '$id',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subscription:',
                              style: Theme.of(context).textTheme.bodyText1),
                          Text(
                            '$subscription'.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Bandwidth:',
                              style: Theme.of(context).textTheme.bodyText1),
                          Text(
                            '${bandwidth.round()} MB / ${bandwidthLimit.round()} MB',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // RaisedButton(
              //   child: Text('CLICK ME!!'),
              //   onPressed: () {},
              // ),
            ],
          ),
        ),
      ),
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
