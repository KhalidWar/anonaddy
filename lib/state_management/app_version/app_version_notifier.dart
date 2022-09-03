import 'package:anonaddy/models/app_version/app_version_model.dart';
import 'package:anonaddy/services/app_version/app_version_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appVersionProvider = FutureProvider.autoDispose<AppVersion>((ref) async {
  return await ref.read(appVersionService).getAppVersionData();
});
