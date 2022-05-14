import 'package:anonaddy/models/account/account.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/utilities/niche_method.dart';
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
        child: avatarChild(context),
      ),
      title: Text(
        NicheMethod.capitalizeFirstLetter(account.username),
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.white),
      ),
      subtitle: Text(
        NicheMethod.capitalizeFirstLetter(
            account.subscription ?? AppStrings.selfHosted),
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.white),
      ),
      trailing: const Icon(Icons.error_outline, color: Colors.white),
      onTap: onPress,
    );
  }

  Widget avatarChild(BuildContext context) {
    final firstLetter = account.username[0];
    return Text(
      firstLetter.toUpperCase(),
      style: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
    );
  }
}
