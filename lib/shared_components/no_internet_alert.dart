import 'package:flutter/material.dart';

class NoInternetAlert extends StatelessWidget {
  const NoInternetAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.05,
      width: double.infinity,
      color: Colors.red,
      child: Center(
        child: Text(
          'No Internet Connection',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
