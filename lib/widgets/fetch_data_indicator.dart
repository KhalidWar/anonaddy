import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FetchingDataIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 15),
            Text('Fetching data...'),
          ],
        ),
      ),
    );
  }
}
