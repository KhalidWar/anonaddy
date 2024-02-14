import 'dart:async';

import 'package:anonaddy/features/account/data/account_data_storage.dart';
import 'package:anonaddy/features/account/data/account_service.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/aliases/data/alias_data_storage.dart';
import 'package:anonaddy/features/aliases/data/alias_service.dart';
import 'package:anonaddy/features/aliases/presentation/controller/alias_screen_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/alias_screen_state.dart';
import 'package:anonaddy/features/aliases/presentation/controller/aliases_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/aliases_state.dart';
import 'package:anonaddy/features/auth/data/auth_service.dart';
import 'package:anonaddy/features/auth/data/biometric_auth_service.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_state.dart';
import 'package:anonaddy/features/domain_options/data/domain_options_service.dart';
import 'package:anonaddy/features/domain_options/domain/domain_options.dart';
import 'package:anonaddy/features/domain_options/presentation/controller/domain_options_notifier.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:anonaddy/features/search/presentation/controller/search_history_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockAuthNotifier extends AuthNotifier {
  MockAuthNotifier({
    required this.authState,
    this.throwError = false,
  });

  final AuthState authState;
  final bool throwError;

  @override
  FutureOr<AuthState> build() async {
    if (throwError) throw 'error';

    return authState;
  }
}

class MockAccountNotifier extends AccountNotifier {
  MockAccountNotifier({required this.account});

  final Account account;

  @override
  Future<Account> build() async {
    return account;
  }
}

class MockDomainOptionsNotifier extends DomainOptionsNotifier {
  MockDomainOptionsNotifier({
    required this.domainOptions,
    this.throwError = false,
  });

  final DomainOptions domainOptions;
  final bool throwError;

  @override
  FutureOr<DomainOptions> build() {
    if (throwError) throw 'error';

    return domainOptions;
  }
}

class MockAliasesNotifier extends AliasesNotifier {
  MockAliasesNotifier({
    required this.aliasesState,
    this.throwError = false,
  });

  final AliasesState aliasesState;
  final bool throwError;

  @override
  Future<void> fetchAliases() async {}

  @override
  FutureOr<AliasesState> build() async {
    if (throwError) throw 'error';

    return aliasesState;
  }
}

class MockRecipientsNotifier extends RecipientsNotifier {
  MockRecipientsNotifier({
    required this.recipients,
    this.throwError = false,
  });

  final List<Recipient> recipients;
  final bool throwError;

  @override
  FutureOr<List<Recipient>> build() async {
    if (throwError) throw 'error';

    return recipients;
  }
}

class MockAliasScreenNotifier extends AliasScreenNotifier {
  MockAliasScreenNotifier({
    required this.aliasScreenState,
    this.throwError = false,
  });

  final AliasScreenState aliasScreenState;
  final bool throwError;

  @override
  FutureOr<AliasScreenState> build(String arg) {
    if (throwError) throw 'error';

    return aliasScreenState;
  }
}

class MockAccountService extends Mock implements AccountService {}

class MockAccountDataStorage extends Mock implements AccountDataStorage {}

class MockDataStorage extends Mock implements AliasDataStorage {}

class MockAliasService extends Mock implements AliasService {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockDomainOptionsService extends Mock implements DomainOptionsService {}

class MockAccessTokenService extends Mock implements AuthService {}

class MockSearchHistoryNotifier extends Mock implements SearchHistoryNotifier {}

class MockBiometricService extends Mock implements BiometricAuthService {}
