import 'package:anonaddy/features/account/data/account_data_storage.dart';
import 'package:anonaddy/features/account/data/account_service.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/aliases/data/alias_data_storage.dart';
import 'package:anonaddy/features/aliases/data/alias_service.dart';
import 'package:anonaddy/features/auth/data/auth_service.dart';
import 'package:anonaddy/features/auth/data/biometric_auth_service.dart';
import 'package:anonaddy/features/domain_options/data/domain_options_service.dart';
import 'package:anonaddy/notifiers/alias_state/aliases_notifier.dart';
import 'package:anonaddy/notifiers/search/search_history/search_history_notifier.dart';
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
