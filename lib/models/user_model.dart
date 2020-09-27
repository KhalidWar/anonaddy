class UserModel {
  UserModel({
    this.id,
    this.subscription,
    this.lastUpdated,
    this.bandwidth,
    this.bandwidthLimit,
    this.aliasCount,
    this.aliasLimit,
    this.username,
  });

  final String id, username, subscription, lastUpdated;
  final double bandwidth, bandwidthLimit;
  final int aliasCount, aliasLimit;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['data']['username'],
      id: json['data']['id'],
      bandwidth: json['data']['bandwidth'] / 1024000,
      bandwidthLimit: json['data']['bandwidth_limit'] / 1024000,
      subscription: json['data']['subscription'],
      lastUpdated: json['data']['updated_at'],
      aliasCount: json['data']['active_shared_domain_alias_count'],
      aliasLimit: json['data']['active_shared_domain_alias_limit'],
    );
  }
}
