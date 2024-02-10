import 'package:anonaddy/notifiers/account/account_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/aliases_notifier.dart';
import 'package:anonaddy/notifiers/search/search_history/search_history_notifier.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/services/data_storage/account_data_storage.dart';
import 'package:anonaddy/services/data_storage/alias_data_storage.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockAccountNotifier extends Mock implements AccountNotifier {}

class MockAccountService extends Mock implements AccountService {}

class MockAccountDataStorage extends Mock implements AccountDataStorage {}

class MockDataStorage extends Mock implements AliasDataStorage {}

class MockAliasService extends Mock implements AliasService {}

class MockAliasTabNotifier extends Mock implements AliasesNotifier {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockDomainOptionsService extends Mock implements DomainOptionsService {}

class MockAccessTokenService extends Mock implements AuthService {}

class MockSearchHistoryNotifier extends Mock implements SearchHistoryNotifier {}

class MockBiometricService extends Mock implements BiometricAuthService {}
