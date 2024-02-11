import 'package:flutter/material.dart';

class CreateAliasErrorWidget extends StatelessWidget {
  const CreateAliasErrorWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Text(message),
    );
  }
}
