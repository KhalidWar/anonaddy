import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RateAddyManager extends StatelessWidget {
  const RateAddyManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        leading: Image.asset('assets/images/play_store.png'),
        title: Text(
          'Enjoying AddyManager?',
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white),
        ),
        subtitle: Text(
          'Tap here to rate it on the App Store.',
          style: TextStyle(color: Colors.white),
        ),
        onTap: () => context.read(nicheMethods).launchURL(
              PlatformAware.isIOS()
                  ? kAddyManagerAppStoreURL
                  : kAddyManagerPlayStoreURL,
            ),
      ),
    );
  }
}
