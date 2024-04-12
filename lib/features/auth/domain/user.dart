import 'package:anonaddy/features/auth/domain/api_token.dart';

class User {
  const User({
    required this.url,
    required this.token,
    required this.apiToken,
  });

  final String url;
  final String token;
  final ApiToken apiToken;

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'token': token,
      'apiToken': apiToken.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      url: map['url'] as String,
      token: map['token'] as String,
      apiToken: ApiToken.fromMap(map['apiToken']),
    );
  }
}

extension UserExtension on User {
  bool get isSelfHosting => url != 'app.addy.io';

  bool get hasTokenExpired =>
      apiToken.expiresAt != null &&
      apiToken.expiresAt!.isBefore(DateTime.now());
}
