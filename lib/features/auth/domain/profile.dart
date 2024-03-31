/// This Object represents accounts on addy.io or self hosted instances.
class Profile {
  Profile({
    required this.instanceUrl,
    required this.accessToken,
  });

  String instanceUrl;
  String accessToken;
}
