import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants/ui_strings.dart';
import 'custom_loading_indicator.dart';

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
