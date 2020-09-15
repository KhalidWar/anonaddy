import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SvgPicture.asset('assets/images/logo-dark.svg'),
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
    );
  }
}
