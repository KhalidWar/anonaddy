import 'package:anonaddy/models/profile/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileService {
  const ProfileService({required this.secureStorage});
  final FlutterSecureStorage secureStorage;

  static const _profileStorageKey = 'profileStorageKey';

  /// Fetches list of profiles
  Future<List<Profile>> fetchProfiles() async {
    final profiles = <Profile>[];
    return profiles;
  }

  /// Stores profiles
  Future<void> saveProfile(String url, token) async {}

  /// Delete a profile
  Future<void> deleteProfile(String token) async {}
}
