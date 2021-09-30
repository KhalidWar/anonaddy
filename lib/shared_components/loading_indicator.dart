import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global_providers.dart';
import 'constants/ui_strings.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final customLoading =
        context.read(customLoadingIndicator).customLoadingIndicator();

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
