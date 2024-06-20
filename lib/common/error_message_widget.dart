import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    super.key,
    required this.message,
    this.messageColor,
  });

  final String message;
  final Color? messageColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: messageColor),
      ),
    );
  }
}
