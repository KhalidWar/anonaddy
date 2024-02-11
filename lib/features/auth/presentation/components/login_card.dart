import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: size.height * 0.68,
      width: size.width * 0.85,
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).cardTheme.color
            : Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: child,
    );
  }
}
