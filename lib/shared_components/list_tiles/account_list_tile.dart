import 'package:anonaddy/shared_components/constants/addymanager_string.dart';
import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    Key? key,
    this.title,
    required this.subtitle,
    required this.leadingIconData,
    this.trailingIcon,
    this.onTap,
  }) : super(key: key);

  final String? title;
  final String subtitle;
  final IconData leadingIconData;
  final Widget? trailingIcon;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(leadingIconData, color: Colors.white),
            SizedBox(width: size.width * 0.04),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? AppStrings.noDefaultSelected,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            IgnorePointer(child: trailingIcon),
          ],
        ),
      ),
    );
  }
}
