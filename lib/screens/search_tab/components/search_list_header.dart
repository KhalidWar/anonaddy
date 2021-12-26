import 'package:flutter/material.dart';

class SearchListHeader extends StatelessWidget {
  const SearchListHeader({
    Key? key,
    required this.title,
    required this.buttonLabel,
    required this.onPress,
    this.buttonTextColor,
  }) : super(key: key);

  final String title, buttonLabel;
  final Function() onPress;
  final Color? buttonTextColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton(
                child: Text(
                  buttonLabel,
                  style: TextStyle(color: buttonTextColor),
                ),
                onPressed: onPress,
              ),
            ],
          ),
        ),
        Divider(height: 0),
      ],
    );
  }
}
