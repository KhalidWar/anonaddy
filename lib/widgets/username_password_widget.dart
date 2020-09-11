import 'package:flutter/material.dart';

class UsernamePasswordWidget extends StatelessWidget {
  const UsernamePasswordWidget({
    Key key,
    this.label,
    this.hintText,
  }) : super(key: key);

  final String label, hintText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: size.height * 0.01),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hintText,
          ),
          onChanged: (input) {},
        )
      ],
    );
  }
}
