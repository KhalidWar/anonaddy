import 'package:flutter/material.dart';

import '../constants.dart';

class AccountInfoCard extends StatelessWidget {
  const AccountInfoCard({
    Key key,
    @required this.username,
    @required this.id,
    @required this.subscription,
    @required this.bandwidth,
    @required this.bandwidthLimit,
  }) : super(key: key);

  final String username;
  final String id;
  final String subscription;
  final double bandwidth;
  final double bandwidthLimit;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '$username'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
                height: 25,
                indent: size.width * 0.3,
                endIndent: size.width * 0.3,
                color: kAppBarColor,
                thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID:', style: Theme.of(context).textTheme.bodyText1),
                Text(
                  '$id',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subscription:',
                    style: Theme.of(context).textTheme.bodyText1),
                Text(
                  '$subscription'.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bandwidth:',
                    style: Theme.of(context).textTheme.bodyText1),
                Text(
                  '${bandwidth.round()} MB / ${bandwidthLimit.round()} MB',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
