import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lottie/lottie.dart';

class CreditsScreen extends StatelessWidget {
  final _launchURL = NicheMethod().launchURL;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Credits')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Listed below are third party assets used in AddyManager.',
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Divider(height: 0),
          buildTile(
            context: context,
            lottieFile: 'assets/lottie/errorCone.json',
            title: 'Error Cone',
            creator: 'Fernando Ron Pedrique',
            lottieURL: 'https://lottiefiles.com/38064-error-cone',
          ),
          buildTile(
            context: context,
            lottieFile: 'assets/lottie/empty.json',
            title: 'Empty',
            creator: '张先生',
            lottieURL: 'https://lottiefiles.com/13525-empty',
          ),
        ],
      ),
    );
  }

  Widget buildTile(
      {BuildContext context,
      String lottieFile,
      String title,
      String creator,
      String lottieURL}) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Lottie.asset(
                      lottieFile,
                      height: size.height * 0.18,
                      width: size.width * 0.35,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(creator),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.open_in_new_outlined),
              ],
            ),
            Divider(height: 0),
          ],
        ),
      ),
      onTap: () => _launchURL(lottieURL),
    );
  }
}
