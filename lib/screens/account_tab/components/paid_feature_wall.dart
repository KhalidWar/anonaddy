import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:flutter/material.dart';

class PaidFeatureWall extends StatelessWidget {
  const PaidFeatureWall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        ToastMessage.onlyAvailableToPaid,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
