import 'package:anonaddy/screens/create_alias/components/create_alias_card.dart';
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
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return CreateAliasCard(
      onPress: onPress,
      header: label,
      subHeader: label,
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(0),
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        title: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.keyboard_arrow_down_rounded),
      ),
    );
  }
}
