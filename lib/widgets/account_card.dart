import 'package:anonaddy/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    Key key,
    this.userData,
  }) : super(key: key);

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.account_circle_outlined),
                Text(
                  '${userData.username}',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID:', style: Theme.of(context).textTheme.bodyText1),
                    Text(
                      '${userData.id}',
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
                      '${userData.subscription}'.toUpperCase(),
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
                      '${userData.bandwidth.round()} MB / ${userData.bandwidthLimit.round()} MB',
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
                      '${userData.aliasCount} / ${userData.aliasLimit}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
