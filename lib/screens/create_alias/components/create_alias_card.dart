import 'package:flutter/material.dart';

class CreateAliasCard extends StatelessWidget {
  const CreateAliasCard({
    Key? key,
    required this.header,
    required this.subHeader,
    required this.child,
    this.onPress,
    this.showIcon = true,
  }) : super(key: key);

  final String header, subHeader;
  final Widget child;
  final Function()? onPress;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            header,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              subHeader,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          const Divider(height: 0),
          InkWell(
            onTap: onPress,
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              minVerticalPadding: 0,
              horizontalTitleGap: 0,
              title: child,
              trailing: showIcon
                  ? const Icon(Icons.keyboard_arrow_down_rounded)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
