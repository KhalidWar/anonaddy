import 'package:anonaddy/common/constants/lottie_images.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

@RoutePage(name: 'CreditsScreenRoute')
class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Credits')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Listed below are third party assets used in AddyManager.',
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 0),
          buildTile(
            context: context,
            lottieFile: LottieImages.emptyResult,
            title: 'Empty',
            creator: '张先生',
            lottieURL: 'https://lottiefiles.com/13525-empty',
          ),
          buildTile(
            context: context,
            lottieFile: LottieImages.biometricAnimation,
            title: 'Biometric Animation',
            creator: 'Clément Boissy',
            lottieURL:
                'https://lottiefiles.com/8185-biometrics-android-animation',
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

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
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
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(creator),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.open_in_new_outlined),
              ],
            ),
            const Divider(height: 0),
          ],
        ),
      ),
      onTap: () => Utilities.launchURL(lottieURL),
    );
  }
}
