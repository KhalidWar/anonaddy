import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';

class HeaderProfile extends StatelessWidget {
  const HeaderProfile({
    Key? key,
    required this.account,
    required this.onPress,
  }) : super(key: key);

  final Account account;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.accentColor,
        child: Text(
          account.username[0].toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
        ),
      ),
      title: Text(
        Utilities.capitalizeFirstLetter(account.username),
      ),
      subtitle: Text(
        Utilities.capitalizeFirstLetter(
          account.isSelfHosted ? AppStrings.selfHosted : account.subscription,
        ),
      ),
      trailing: const Icon(Icons.error_outline, color: Colors.white),
      onTap: onPress,
    );
  }
}
