import 'package:anonaddy/constants.dart';
import 'package:anonaddy/widgets/custom_loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final customLoading = CustomLoadingIndicator().customLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customLoading,
          SizedBox(height: 15),
          Text(kLoadingText),
        ],
      ),
    );
  }
}
