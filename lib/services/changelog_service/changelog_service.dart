import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangelogService {
  final _secureStorage = FlutterSecureStorage();
  final _changelogKey = 'changelogKey';

  Future<bool> isAppUpdated() async {
    return await _secureStorage.read(key: _changelogKey).then((value) {
      if (value == 'true' || value == null) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<void> markAppUpdated() async {
    _secureStorage.write(key: _changelogKey, value: false.toString());
  }
}
