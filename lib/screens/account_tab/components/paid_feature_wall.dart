import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:flutter/material.dart';

class PaidFeatureWall extends StatelessWidget {
  const PaidFeatureWall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        ToastMessage.onlyAvailableToPaid,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
