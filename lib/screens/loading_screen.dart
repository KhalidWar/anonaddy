import 'package:anonaddy/constants.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
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
