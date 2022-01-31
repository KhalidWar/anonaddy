import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/screens/home_screen/components/changelog_widget.dart';
import 'package:anonaddy/services/changelog_service/changelog_service.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final changelogStateNotifier = StateNotifierProvider((ref) {
  return ChangelogNotifier(changelogService: ref.read(changelogService));
});

class ChangelogNotifier extends StateNotifier {
  ChangelogNotifier({required this.changelogService}) : super(null) {
    /// Check if app has updated
    checkIfAppUpdated();
  }

  final ChangelogService changelogService;

  /// Show [ChangelogWidget] if app has been updated
  Future<void> showChangelogWidget(BuildContext context) async {
    final isUpdated = await isAppUpdated();
    if (isUpdated) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(kBottomSheetBorderRadius)),
        ),
        builder: (context) => const ChangelogWidget(),
      );
    }
  }

  Future<bool> isAppUpdated() async {
    final data = await changelogService.getChangelogStatus();
    final isUpdated = data == null || data == 'true';
    return isUpdated;
  }

  Future<void> markChangelogRead() async {
    await changelogService.markChangelogRead();
  }

  /// Compare current app version number to the old version number.
  Future<void> checkIfAppUpdated() async {
    final oldAppVersion = await changelogService.loadOldAppVersion();
    final currentAppVersion = await changelogService.getCurrentAppVersion();

    if (oldAppVersion != currentAppVersion) {
      /// If numbers do NOT match, meaning app has been updated, delete
      /// changelog value from the storage so that [ChangelogWidget] is displayed
      await changelogService.deleteChangelogStatus();

      /// Then save current AppVersion's number to acknowledge that the user
      /// has opened app with this version before.
      await changelogService.saveCurrentAppVersion(currentAppVersion);
    }
  }
}
