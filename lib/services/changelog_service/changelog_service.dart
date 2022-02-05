import 'package:anonaddy/shared_components/constants/changelog_storage_key.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangelogService {
  ChangelogService(this.secureStorage);
  final FlutterSecureStorage secureStorage;

  Future<String?> getChangelogStatus() async {
    final status =
        await secureStorage.read(key: ChangelogStorageKey.changelogKey);
    return status;
  }

  /// Marks [Changelog] as read so it doesn't show it again on app restart
  Future<void> markChangelogRead() async {
    await secureStorage.write(
        key: ChangelogStorageKey.changelogKey, value: false.toString());
  }
}
