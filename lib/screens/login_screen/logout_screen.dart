import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:flutter/material.dart';

class LogoutScreen extends StatefulWidget {
  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  //todo delete all app data
  @override
  void initState() {
    super.initState();
  }

  //todo dispose of all providers and navigate to login screen
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueNavyColor,
      body: Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
