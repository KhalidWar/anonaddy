import 'package:anonaddy/features/settings/presentation/controller/settings_notifier.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:anonaddy/utilities/package_info_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangelogWidget extends ConsumerWidget {
  const ChangelogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What\'s new?',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Consumer(
                    builder: (_, ref, __) {
                      final appInfo = ref.watch(packageInfoProvider);
                      return appInfo.when(
                        data: (data) => Text('Version: ${data.version}'),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) => Text(error.toString()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(height: 0),
            buildBody(context, controller),
            SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  child: const Text('Continue to AddyManager'),
                  onPressed: () {
                    ref.read(settingsNotifier.notifier).dismissChangelog();
                    Navigator.pop(context);
                  },
                ),
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
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            header('Added', Colors.green),
            label('1. Matching Addy.io rebrand'),
            header('Fixed', Colors.blue),
            label('1. Minor functionality bugs.'),
            label('2. Several UI bugs.'),
            label('3. Several flow bugs.'),
            header('Improved', Colors.orange),
            label('1. Overhauled Create New Alias'),
            label('2. Several bug fixes'),
            label('3. Several under the hood improvements'),
            // label('2. Fixed self-hosted recipient/username count errors.'),
            // SizedBox(height: size.height * 0.008),
            // header('Added', Colors.green),
            // label('1. Added Native splash screen.'),
            // label('2. Added animation to FloatingActionButton.'),
            // SizedBox(height: size.height * 0.008),
            // header('Improvements', Colors.orange),
            // label('1. Improved app startup.'),
            // label('2. Improved CreateAlias UI.'),
            // label('3. Improved several under the hood functionalities.'),
            // label('4. Improved several UI components.'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
