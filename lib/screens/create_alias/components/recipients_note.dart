import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:flutter/material.dart';

class RecipientsNote extends StatelessWidget {
  const RecipientsNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 0),
          SizedBox(height: size.height * 0.01),
          Text(
            kUpdateAliasRecipientNote,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
