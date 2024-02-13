import 'package:anonaddy/features/app_version/data/app_version_service.dart';
import 'package:anonaddy/features/app_version/domain/app_version_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() async {
  late MockDio mockDio;
  late AppVersionService appVersionService;

  setUp(() {
    mockDio = MockDio();
    appVersionService = AppVersionService(dio: mockDio);
  });

  test(
      'Given appVersionService and dio are up and running, '
      'When appVersionService.getAppVersionData(path) is called, '
      'Then future completes and returns an appVersion data.', () async {
    when(() => mockDio.get(any())).thenAnswer(
      (_) => Future.value(
        Response(
          requestOptions: RequestOptions(path: 'path'),
          statusCode: 200,
          data: {'version': '1.0.0', 'major': 1, 'minor': 0, 'patch': 0},
        ),
      ),
    );

    // Act
    final dioGet = mockDio.get('path');
    final appVersion = await appVersionService.getAppVersionData('path');

    // Assert
    expectLater(dioGet, completes);
    expect(await dioGet, isA<Response>());

    expect(appVersion, isA<AppVersion>());
    expect(appVersion.version, '1.0.0');
    expect(appVersion.major, 1);
    expect(appVersion.minor, 0);
    expect(appVersion.patch, 0);
  });
}
