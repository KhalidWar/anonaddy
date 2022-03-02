import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(
          'AddyManager',
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Divider(
          color: const Color(0xFFE4E7EB),
          thickness: 2,
          indent: size.width * 0.30,
          endIndent: size.width * 0.30,
        ),
      ],
    );
  }
}
