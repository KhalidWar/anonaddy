import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:anonaddy/services/user/user_service.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:flutter_riverpod/all.dart';

final usernameServiceProvider = Provider((ref) => UsernameService());
final userServiceProvider = Provider((ref) => UserService());
final aliasServiceProvider = Provider((ref) => AliasService());
final domainOptionsServiceProvider = Provider((ref) => DomainOptionsService());
final accessTokenServiceProvider = Provider((ref) => AccessTokenService());
