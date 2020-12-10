class UserModel {
  const UserModel({
    this.id,
    this.username,
    this.fromName,
    this.emailSubject,
    this.bannerLocation,
    this.bandwidth,
    this.usernameCount,
    this.usernameLimit,
    this.defaultRecipientId,
    this.defaultAliasDomain,
    this.defaultAliasFormat,
    this.subscription,
    this.bandwidthLimit,
    this.recipientCount,
    this.recipientLimit,
    this.activeDomainCount,
    this.activeDomainLimit,
    this.aliasCount,
    this.aliasLimit,
    this.createdAt,
    this.lastUpdated,
  });

  final String id;
  final String username;
  final dynamic fromName;
  final dynamic emailSubject;
  final String bannerLocation;
  final int bandwidth;
  final int usernameCount;
  final int usernameLimit;
  final String defaultRecipientId;
  final String defaultAliasDomain;
  final String defaultAliasFormat;
  final String subscription;
  final int bandwidthLimit;
  final int recipientCount;
  final int recipientLimit;
  final int activeDomainCount;
  final int activeDomainLimit;
  final int aliasCount;
  final int aliasLimit;
  final DateTime createdAt;
  final DateTime lastUpdated;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['data']["id"],
      username: json['data']["username"],
      fromName: json['data']["from_name"],
      emailSubject: json['data']["email_subject"],
      bannerLocation: json['data']["banner_location"],
      bandwidth: json['data']["bandwidth"],
      usernameCount: json['data']["username_count"],
      usernameLimit: json['data']["username_limit"],
      defaultRecipientId: json['data']["default_recipient_id"],
      defaultAliasDomain: json['data']["default_alias_domain"],
      defaultAliasFormat: json['data']["default_alias_format"],
      subscription: json['data']["subscription"],
      bandwidthLimit: json['data']["bandwidth_limit"],
      recipientCount: json['data']["recipient_count"],
      recipientLimit: json['data']["recipient_limit"],
      activeDomainCount: json['data']["active_domain_count"],
      activeDomainLimit: json['data']["active_domain_limit"],
      aliasCount: json['data']["active_shared_domain_alias_count"],
      aliasLimit: json['data']["active_shared_domain_alias_limit"],
      createdAt: DateTime.parse(json['data']["created_at"]),
      lastUpdated: DateTime.parse(json['data']["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "from_name": fromName,
        "email_subject": emailSubject,
        "banner_location": bannerLocation,
        "bandwidth": bandwidth,
        "username_count": usernameCount,
        "username_limit": usernameLimit,
        "default_recipient_id": defaultRecipientId,
        "default_alias_domain": defaultAliasDomain,
        "default_alias_format": defaultAliasFormat,
        "subscription": subscription,
        "bandwidth_limit": bandwidthLimit,
        "recipient_count": recipientCount,
        "recipient_limit": recipientLimit,
        "active_domain_count": activeDomainCount,
        "active_domain_limit": activeDomainLimit,
        "active_shared_domain_alias_count": aliasCount,
        "active_shared_domain_alias_limit": aliasLimit,
        "created_at": createdAt.toIso8601String(),
        "updated_at": lastUpdated.toIso8601String(),
      };
}
