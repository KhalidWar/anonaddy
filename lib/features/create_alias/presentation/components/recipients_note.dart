import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:flutter/material.dart';

class RecipientsNote extends StatelessWidget {
  const RecipientsNote({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 0),
          SizedBox(height: size.height * 0.01),
          Text(
            AppStrings.updateAliasRecipientNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
