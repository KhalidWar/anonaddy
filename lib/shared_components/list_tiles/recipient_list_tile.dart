import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:flutter/material.dart';

class RecipientListTile extends StatelessWidget {
  const RecipientListTile({
    Key? key,
    required this.recipient,
    required this.onPress,
    this.isSelected = false,
  }) : super(key: key);

  final Recipient recipient;
  final bool isSelected;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onPress,
      selected: isSelected,
      selectedTileColor: AppColors.primaryColor,
      leading: const Icon(Icons.email_outlined),
      title: Text(recipient.email),
      subtitle: recipient.isVerified
          ? Text(
              AppStrings.verified,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.green),
            )
          : Text(
              AppStrings.unverified,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.red),
            ),
    );
  }
}
