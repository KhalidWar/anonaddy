import 'package:anonaddy/constants.dart';
import 'package:anonaddy/widgets/username_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kAppBarColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/logo.svg',
                width: size.width * 0.5,
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                height: size.height * 0.6,
                width: size.width * 0.8,
                padding: EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Welcome Back!',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Divider(
                          color: Color(0xFFE4E7EB),
                          thickness: 2,
                          indent: size.width * 0.22,
                          endIndent: size.width * 0.22,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          UsernamePasswordWidget(
                            label: 'Username:',
                            hintText: 'johndoe',
                          ),
                          SizedBox(height: size.height * 0.02),
                          UsernamePasswordWidget(
                            label: 'Password:',
                            hintText: '********',
                          ),
                          SizedBox(height: size.height * 0.01),
                          GestureDetector(
                            child: Text('Forgot Password?'),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: size.height * 0.1,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: RaisedButton(
                        child: Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                'Don\'t have an account? REGISTER',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
