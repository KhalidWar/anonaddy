import 'package:flutter/material.dart';

class SearchListHeader extends StatelessWidget {
  const SearchListHeader({
    super.key,
    required this.title,
    required this.buttonLabel,
    required this.onPress,
    this.buttonTextColor,
  });

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
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: onPress,
                child: Text(
                  buttonLabel,
                  style: TextStyle(color: buttonTextColor),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}
