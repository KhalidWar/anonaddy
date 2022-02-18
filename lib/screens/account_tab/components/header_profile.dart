import 'package:flutter/material.dart';

import '../../../models/account/account.dart';

class HeaderProfile extends StatelessWidget {
  const HeaderProfile({
    Key? key,
    required this.account,
    required this.onPress,
  }) : super(key: key);
  final Account account;
  final Function() onPress;

  String _capitalize(String input) {
    final firstLetter = input[0];
    return input.replaceFirst(firstLetter, firstLetter.toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.red,
        child: avatarChild(context),
      ),
      title: Text(
        _capitalize(account.username),
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.white),
      ),
      subtitle: Text(
        _capitalize(account.subscription ?? 'Self Hosted'),
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
      style:
          Theme.of(context).textTheme.headline5!.copyWith(color: Colors.black),
    );
  }
}
