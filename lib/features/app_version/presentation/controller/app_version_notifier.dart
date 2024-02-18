import 'package:anonaddy/features/app_version/data/app_version_service.dart';
import 'package:anonaddy/features/app_version/domain/app_version.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appVersionProvider = FutureProvider.autoDispose<AppVersion>((ref) async {
  return await ref.read(appVersionService).getAppVersionData();
});
