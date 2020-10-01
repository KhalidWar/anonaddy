import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    Key key,
    this.username,
    this.id,
    this.subscription,
    this.bandwidth,
    this.bandwidthLimit,
    this.aliasCount,
    this.aliasLimit,
  }) : super(key: key);

  final String username, id, subscription;
  final double bandwidth, bandwidthLimit;
  final int aliasCount, aliasLimit;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                '$username'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: size.height * 0.02),
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
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Aliases',
                    style: Theme.of(context).textTheme.bodyText1),
                Text(
                  '$aliasCount / $aliasLimit',
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
