import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/logo.svg',
            height: size.height * 0.05,
          ),
          SizedBox(height: size.height * 0.03),
          CircularProgressIndicator(key: Key('loadingIndicator')),
        ],
      ),
    );
  }
}
