import 'package:anonaddy/shared_components/constants/hive_type_id.dart';
import 'package:hive/hive.dart';

part 'profile.g.dart';

/// HiveType is assigned a unique typeId and registered to save
/// object in Hive DB storage.
/// For more info: https://docs.hivedb.dev/#/custom-objects/generate_adapter
@HiveType(typeId: HiveTypeId.profile)

/// This Object represents accounts on AnonAddy or self hosted instances.
class Profile extends HiveObject {
  Profile({required this.instanceUrl, required this.accessToken});

  @HiveField(0)
  String instanceUrl;

  @HiveField(1)
  String accessToken;
}
