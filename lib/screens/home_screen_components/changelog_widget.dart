import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

class ChangelogWidget extends StatelessWidget {
  const ChangelogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (context, controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 3,
              indent: size.width * 0.44,
              endIndent: size.width * 0.44,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What\'s new?',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Consumer(
                    builder: (_, watch, __) {
                      final appInfo = watch(packageInfoProvider);
                      return appInfo.when(
                        data: (data) => Text('Version: ${data.version}'),
                        loading: () => CircularProgressIndicator(),
                        error: (error, stackTrace) => Text(error.toString()),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(height: 0),
            buildBody(context, controller),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                child: const Text('Continue to AddyManager'),
                onPressed: () {
                  context.read(changelogService).dismissChangeLog();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  //todo automate changelog fetching
  Widget buildBody(BuildContext context, ScrollController controller) {
    final size = MediaQuery.of(context).size;

    /// header('Fixed', Colors.blue),
    /// header('Added', Colors.green),
    /// header('Removed', Colors.red),
    /// header('Improved', Colors.orange),

    Widget header(String label, Color color) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Text(
          label,
          style: Theme.of(context).textTheme.headline6!.copyWith(color: color),
        ),
      );
    }

    Widget label(String title) {
      return Text(
        title,
        style: Theme.of(context).textTheme.subtitle1,
      );
    }

    return Expanded(
      child: PlatformScrollbar(
        child: ListView(
          controller: controller,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            header('Fixed', Colors.blue),
            label('1. Squashed several bugs.'),
            SizedBox(height: size.height * 0.008),
            header('Added', Colors.green),
            label('1. Added AnonAddy FAQ and Help Center to Settings screen.'),
            SizedBox(height: size.height * 0.008),
            header('Improved', Colors.orange),
            label(
                '1. Improved how alias, recipient, domain, and username data are loaded.'),
            SizedBox(height: size.height * 0.008),
            label('2. Several under the hood improvements.'),
            SizedBox(height: size.height * 0.008),
            label('3. Improved navigation system and flow throughout the app.'),
            SizedBox(height: size.height * 0.008),
            label('4. Updated several UI components'),
            SizedBox(height: size.height * 0.008),
            label(
                '5. Too many  other improvements to list. Check out our github repo for fully detailed changelog.'),
            SizedBox(height: size.height * 0.008),
          ],
        ),
      ),
    );
  }
}
