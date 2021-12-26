import 'package:anonaddy/services/changelog_service/changelog_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ChangelogService {
  const ChangelogService(this.changelogStorage);

  final ChangelogStorage changelogStorage;

  Future<bool> isAppUpdated() async {
    final data = await changelogStorage.getChangelogStatus();
    final isUpdated = data == null || data == 'true';
    return isUpdated;
  }

  Future<void> markChangelogRead() async {
    await changelogStorage.markChangelogRead();
  }

  /// Compare current app version number to the old version number.
  Future<void> checkIfAppUpdated() async {
    final oldAppVersion = await changelogStorage.loadOldAppVersion();
    final currentAppVersion = await _getCurrentAppVersion();

    if (oldAppVersion != currentAppVersion) {
      /// If numbers do NOT match, meaning app has been updated, delete
      /// changelog value from the storage so that [ChangelogWidget] is displayed
      await changelogStorage.deleteChangelogStatus();

      /// Then save current AppVersion's number to acknowledge that the user
      /// has opened app with this version before.
      await changelogStorage.saveCurrentAppVersion(currentAppVersion);
    }
  }

  Future<String> _getCurrentAppVersion() async {
    final appVersion = await PackageInfo.fromPlatform();
    return appVersion.version;
  }
}
