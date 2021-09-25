import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:flutter/material.dart';

class PaidFeatureWall extends StatelessWidget {
  const PaidFeatureWall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        kOnlyAvailableToPaid,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
