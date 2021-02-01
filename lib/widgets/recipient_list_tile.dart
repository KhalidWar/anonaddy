import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/screens/recipient_screen/recipient_detailed_screen.dart';
import 'package:anonaddy/state_management/recipient_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class RecipientListTile extends StatelessWidget {
  const RecipientListTile({Key key, this.recipientDataModel}) : super(key: key);

  final RecipientDataModel recipientDataModel;

  @override
  Widget build(BuildContext context) {
    final recipientDataProvider = context.read(recipientStateManagerProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.email_outlined,
              color: isDark ? Colors.white : Colors.grey,
              size: 30,
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipientDataModel.email),
                SizedBox(height: 2),
                recipientDataModel.emailVerifiedAt == null
                    ? Text(
                        'Unverified',
                        style: TextStyle(color: Colors.red),
                      )
                    : Text(
                        'Verified',
                        style: TextStyle(color: Colors.green),
                      ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        recipientDataProvider.setRecipientData(recipientDataModel);
        recipientDataProvider
            .setEncryptionSwitch(recipientDataModel.shouldEncrypt);

        Navigator.push(
          context,
          PageRouteBuilder(
            transitionsBuilder: (context, animation, secondAnimation, child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.linearToEaseOut);
              return SlideTransition(
                position: Tween(
                  begin: Offset(1.0, 0.0),
                  end: Offset(0.0, 0.0),
                ).animate(animation),
                child: child,
              );
            },
            pageBuilder: (context, animation, secondAnimation) {
              return RecipientDetailedScreen(recipientData: recipientDataModel);
            },
          ),
        );
      },
    );
  }
}
