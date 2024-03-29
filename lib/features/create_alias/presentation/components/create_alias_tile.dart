import 'package:flutter/material.dart';

class CreateAliasTile extends StatelessWidget {
  const CreateAliasTile({
    Key? key,
    required this.title,
    required this.iconData,
    required this.subtitle,
    required this.onPress,
    this.showIcon = true,
  }) : super(key: key);

  final String title, subtitle;
  final IconData iconData;
  final Function() onPress;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(iconData),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: showIcon ? const Icon(Icons.arrow_forward_ios_rounded) : null,
      onTap: onPress,
    );
  }
}
