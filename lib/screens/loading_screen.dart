import 'package:anonaddy/constants.dart';
import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/services/networking.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String baseURL = 'https://app.anonaddy.com/api/v1';
  String accountDetailsURL = 'account-details';
  String aliases = 'aliases';

  Future getAccountDetails() async {
    Networking accountDetails = Networking('$baseURL/$accountDetailsURL');
    var accountData = await accountDetails.getData();

    Networking aliasesDetails = Networking('$baseURL/$aliases');
    var aliasesData = await aliasesDetails.getData();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            accountData: accountData,
            aliasesData: aliasesData,
          ),
        ));
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
        body: Container(
          color: kAppBarColor,
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset('assets/images/logo.svg'),
              SizedBox(height: size.height * 0.03),
              Container(
                height: size.height * 0.1,
                width: size.width * 0.2,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
