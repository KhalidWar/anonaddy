import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_state.dart';
import 'package:anonaddy/features/domain_options/domain/domain_options.dart';
import 'package:anonaddy/features/domain_options/presentation/controller/domain_options_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mocks a successful login [AuthorizationStatus.unknown]
final testAuthStateNotifier =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final testDomainOptionsNotifier =
    AsyncNotifierProvider<DomainOptionsNotifier, DomainOptions>(
        DomainOptionsNotifier.new);
