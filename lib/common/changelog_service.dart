import 'package:anonaddy/common/constants/changelog_storage_key.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final changelogServiceProvider = Provider.autoDispose<ChangelogService>((ref) {
  final secureStorage = ref.read(flutterSecureStorageProvider);
  return ChangelogService(secureStorage: secureStorage);
});

class ChangelogService {
  ChangelogService({required this.secureStorage});

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
