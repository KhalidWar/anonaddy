import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:flutter/material.dart';

class RecipientsTile extends StatelessWidget {
  const RecipientsTile({
    Key? key,
    required this.email,
    required this.isSelected,
    required this.onPress,
  }) : super(key: key);
  final String email;
  final bool isSelected;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isSelected,
      selectedTileColor: AppColors.accentColor,
      horizontalTitleGap: 0,
      title: Text(
        email,
        style: TextStyle(
          color: isSelected
              ? Colors.black
              : Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
      onTap: () => onPress(),
    );
  }
}
