import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:flutter/material.dart';

class SelectRecipientTile extends StatelessWidget {
  const SelectRecipientTile({
    super.key,
    required this.isSelected,
    required this.verifiedRecipient,
    required this.onPress,
  });

  final bool isSelected;
  final Recipient verifiedRecipient;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      selected: isSelected,
      leading: Checkbox(
        value: isSelected,
        onChanged: (value) {},
      ),
      title: Text(verifiedRecipient.email),
      subtitle: Text(
        'Aliases count: ${verifiedRecipient.aliasesCount ?? 'unknown'}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (verifiedRecipient.fingerprint != null)
            const IconButton(
              icon: Icon(Icons.fingerprint_outlined),
              tooltip: 'Verified',
              onPressed: null,
            ),
          if (verifiedRecipient.isEncrypted)
            const IconButton(
              icon: Icon(Icons.lock),
              tooltip: 'Encrypted',
              onPressed: null,
            ),
        ],
      ),
      onTap: onPress,
    );
  }
}
