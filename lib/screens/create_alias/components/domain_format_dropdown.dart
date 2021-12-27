import 'package:flutter/material.dart';

class DomainFormatDropdown extends StatelessWidget {
  const DomainFormatDropdown({
    Key? key,
    required this.title,
    required this.label,
    required this.onPress,
  }) : super(key: key);

  final String title;
  final String label;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
          horizontal: 1,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ],
        ),
      ),
      onTap: () => onPress(),
    );
  }
}
