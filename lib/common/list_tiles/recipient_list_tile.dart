import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:flutter/material.dart';

class RecipientListTile extends StatelessWidget {
  const RecipientListTile({
    super.key,
    required this.recipient,
    required this.onPress,
    this.isSelected = false,
  });

  final Recipient recipient;
  final bool isSelected;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        color: isSelected ? AppColors.accentColor : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.email_outlined),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipient.email),
                recipient.isVerified
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
