import 'package:anonaddy/constants.dart';
import 'package:flutter/material.dart';

class FetchingDataIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 15),
          Text(kFetchingDataText),
        ],
      ),
    );
  }
}
