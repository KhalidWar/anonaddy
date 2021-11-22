import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.red,
      title: Text(
        'No Internet: showing offline data',
        textAlign: TextAlign.center,
      ),
      leading: Icon(Icons.warning),
      trailing: Icon(Icons.warning),
    );
  }
}
