import 'package:anonaddy/models/failed_delivery/failed_delivery.dart';
import 'package:flutter/material.dart';

class FailedDeliveryListTile extends StatelessWidget {
  const FailedDeliveryListTile({
    Key? key,
    required this.delivery,
    required this.onPress,
  }) : super(key: key);
  final FailedDelivery delivery;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedAlignment: Alignment.centerLeft,
      tilePadding: const EdgeInsets.all(0),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 5),
      title: Text(
        delivery.aliasEmail,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(
        delivery.code,
        style: Theme.of(context).textTheme.caption,
      ),
      children: [
        ListTile(
          dense: true,
          title: const Text('Alias'),
          subtitle: Text(delivery.aliasEmail),
        ),
        ListTile(
          dense: true,
          title: const Text('Recipient'),
          subtitle: Text(delivery.recipientEmail ?? 'Not available'),
        ),
        ListTile(
          dense: true,
          title: const Text('Type'),
          subtitle: Text(delivery.bounceType),
        ),
        ListTile(
          dense: true,
          title: const Text('Code'),
          subtitle: Text(delivery.code),
        ),
        ListTile(
          dense: true,
          title: const Text('Remote MTA'),
          subtitle: Text(
            delivery.remoteMta.isEmpty ? 'Not available' : delivery.remoteMta,
          ),
        ),
        ListTile(
          dense: true,
          title: const Text('Created'),
          subtitle: Text(delivery.createdAt.toString()),
        ),
        const Divider(height: 0),
        TextButton(
          onPressed: onPress,
          child: const Text('Delete failed delivery'),
        ),
      ],
    );
  }
}
