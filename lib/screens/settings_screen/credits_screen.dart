import 'package:anonaddy/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class CreditsScreen extends StatelessWidget {
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
          buildTile(
            context: context,
            lottieFile: 'assets/lottie/biometric.json',
            title: 'Biometric Animation',
            creator: 'Clément Boissy',
            lottieURL:
                'https://lottiefiles.com/8185-biometrics-android-animation',
          ),
          buildTile(
            context: context,
            lottieFile: 'assets/lottie/coming_soon.json',
            title: 'Coming Soon',
            creator: 'Arno M. Scharinger',
            lottieURL: 'https://lottiefiles.com/34957-coming-soon',
          ),
        ],
      ),
    );
  }

  Widget buildTile(
      {required BuildContext context,
      required String lottieFile,
      required String title,
      required String creator,
      required lottieURL}) {
    final size = MediaQuery.of(context).size;
    final launchURL = context.read(nicheMethods).launchURL;

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
                    SizedBox(width: 10),
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
      onTap: () => launchURL(lottieURL),
    );
  }
}
