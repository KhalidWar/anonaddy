import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:flutter/material.dart';

class NavigationErrorScreen extends StatelessWidget {
  const NavigationErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Navigation Error')),
      body: Center(
        child: Text(
          navigationErrorMessage,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
