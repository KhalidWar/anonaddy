import 'package:anonaddy/services/access_token_service.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/services/network_service.dart';
import 'package:anonaddy/services/theme_service.dart';
import 'package:flutter_riverpod/all.dart';

final themeServiceProvider = ChangeNotifierProvider((ref) => ThemeService());
final networkServiceProvider = Provider((ref) => NetworkService());
final apiServiceProvider = Provider((ref) => APIService());
final accessTokenServiceProvider = Provider((ref) => AccessTokenService());
