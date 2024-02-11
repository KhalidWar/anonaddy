import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
class Account {
  Account({
    this.id = '',
    this.username = '',
    this.fromName = '',
    this.emailSubject = '',
    this.bannerLocation = '',
    this.bandwidth = 0,
    this.bandwidthLimit = 0,
    this.usernameCount = 0,
    this.usernameLimit = 0,
    this.defaultRecipientId = '',
    this.defaultAliasDomain = '',
    this.defaultAliasFormat = '',
    this.subscription = '',
    this.subscriptionEndAt = '',
    this.recipientCount = 0,
    this.recipientLimit = 0,
    this.activeDomainCount = 0,
    this.activeDomainLimit = 0,
    this.aliasCount = 0,
    this.aliasLimit = 0,
    this.totalEmailsForwarded = 0,
    this.totalEmailsBlocked = 0,
    this.totalEmailsReplied = 0,
    this.totalEmailsSent = 0,
    this.createdAt = '',
    this.lastUpdated = '',
  });

  final String id;
  final String username;

  @JsonKey(name: 'from_name')
  final String fromName;

  @JsonKey(name: 'email_subject')
  final String emailSubject;

  @JsonKey(name: 'banner_location')
  final String bannerLocation;

  final int bandwidth;

  @JsonKey(name: 'bandwidth_limit')
  final int bandwidthLimit;

  @JsonKey(name: 'username_count')
  final int usernameCount;

  @JsonKey(name: 'username_limit')
  final int usernameLimit;

  @JsonKey(name: 'default_recipient_id')
  final String defaultRecipientId;

  @JsonKey(name: 'default_alias_domain')
  final String defaultAliasDomain;

  @JsonKey(name: 'default_alias_format')
  final String defaultAliasFormat;

  final String subscription;

  @JsonKey(name: 'subscription_ends_at')
  final String subscriptionEndAt;

  @JsonKey(name: 'recipient_count')
  final int recipientCount;

  @JsonKey(name: 'recipient_limit')
  final int recipientLimit;

  @JsonKey(name: 'active_domain_count')
  final int activeDomainCount;

  @JsonKey(name: 'active_domain_limit')
  final int activeDomainLimit;

  @JsonKey(name: 'active_shared_domain_alias_count')
  final int aliasCount;

  @JsonKey(name: 'active_shared_domain_alias_limit')
  final int aliasLimit;

  @JsonKey(name: 'total_emails_forwarded')
  final int totalEmailsForwarded;

  @JsonKey(name: 'total_emails_blocked')
  final int totalEmailsBlocked;

  @JsonKey(name: 'total_emails_replied')
  final int totalEmailsReplied;

  @JsonKey(name: 'total_emails_sent')
  final int totalEmailsSent;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String lastUpdated;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  Account copyWith({
    String? id,
    String? username,
    String? fromName,
    String? emailSubject,
    String? bannerLocation,
    int? bandwidth,
    int? bandwidthLimit,
    int? usernameCount,
    int? usernameLimit,
    String? defaultRecipientId,
    String? defaultAliasDomain,
    String? defaultAliasFormat,
    String? subscription,
    String? subscriptionEndAt,
    int? recipientCount,
    int? recipientLimit,
    int? activeDomainCount,
    int? activeDomainLimit,
    int? aliasCount,
    int? aliasLimit,
    int? totalEmailsForwarded,
    int? totalEmailsBlocked,
    int? totalEmailsReplied,
    int? totalEmailsSent,
    String? createdAt,
    String? lastUpdated,
  }) {
    return Account(
      id: id ?? this.id,
      username: username ?? this.username,
      fromName: fromName ?? this.fromName,
      emailSubject: emailSubject ?? this.emailSubject,
      bannerLocation: bannerLocation ?? this.bannerLocation,
      bandwidth: bandwidth ?? this.bandwidth,
      bandwidthLimit: bandwidthLimit ?? this.bandwidthLimit,
      usernameCount: usernameCount ?? this.usernameCount,
      usernameLimit: usernameLimit ?? this.usernameLimit,
      defaultRecipientId: defaultRecipientId ?? this.defaultRecipientId,
      defaultAliasDomain: defaultAliasDomain ?? this.defaultAliasDomain,
      defaultAliasFormat: defaultAliasFormat ?? this.defaultAliasFormat,
      subscription: subscription ?? this.subscription,
      subscriptionEndAt: subscriptionEndAt ?? this.subscriptionEndAt,
      recipientCount: recipientCount ?? this.recipientCount,
      recipientLimit: recipientLimit ?? this.recipientLimit,
      activeDomainCount: activeDomainCount ?? this.activeDomainCount,
      activeDomainLimit: activeDomainLimit ?? this.activeDomainLimit,
      aliasCount: aliasCount ?? this.aliasCount,
      aliasLimit: aliasLimit ?? this.aliasLimit,
      totalEmailsForwarded: totalEmailsForwarded ?? this.totalEmailsForwarded,
      totalEmailsBlocked: totalEmailsBlocked ?? this.totalEmailsBlocked,
      totalEmailsReplied: totalEmailsReplied ?? this.totalEmailsReplied,
      totalEmailsSent: totalEmailsSent ?? this.totalEmailsSent,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          fromName == other.fromName &&
          emailSubject == other.emailSubject &&
          bannerLocation == other.bannerLocation &&
          bandwidth == other.bandwidth &&
          bandwidthLimit == other.bandwidthLimit &&
          usernameCount == other.usernameCount &&
          usernameLimit == other.usernameLimit &&
          defaultRecipientId == other.defaultRecipientId &&
          defaultAliasDomain == other.defaultAliasDomain &&
          defaultAliasFormat == other.defaultAliasFormat &&
          subscription == other.subscription &&
          subscriptionEndAt == other.subscriptionEndAt &&
          recipientCount == other.recipientCount &&
          recipientLimit == other.recipientLimit &&
          activeDomainCount == other.activeDomainCount &&
          activeDomainLimit == other.activeDomainLimit &&
          aliasCount == other.aliasCount &&
          aliasLimit == other.aliasLimit &&
          totalEmailsForwarded == other.totalEmailsForwarded &&
          totalEmailsBlocked == other.totalEmailsBlocked &&
          totalEmailsReplied == other.totalEmailsReplied &&
          totalEmailsSent == other.totalEmailsSent &&
          createdAt == other.createdAt &&
          lastUpdated == other.lastUpdated;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      fromName.hashCode ^
      emailSubject.hashCode ^
      bannerLocation.hashCode ^
      bandwidth.hashCode ^
      bandwidthLimit.hashCode ^
      usernameCount.hashCode ^
      usernameLimit.hashCode ^
      defaultRecipientId.hashCode ^
      defaultAliasDomain.hashCode ^
      defaultAliasFormat.hashCode ^
      subscription.hashCode ^
      subscriptionEndAt.hashCode ^
      recipientCount.hashCode ^
      recipientLimit.hashCode ^
      activeDomainCount.hashCode ^
      activeDomainLimit.hashCode ^
      aliasCount.hashCode ^
      aliasLimit.hashCode ^
      totalEmailsForwarded.hashCode ^
      totalEmailsBlocked.hashCode ^
      totalEmailsReplied.hashCode ^
      totalEmailsSent.hashCode ^
      createdAt.hashCode ^
      lastUpdated.hashCode;

  @override
  String toString() {
    return 'Account{id: $id, username: $username, fromName: $fromName, emailSubject: $emailSubject, bannerLocation: $bannerLocation, bandwidth: $bandwidth, bandwidthLimit: $bandwidthLimit, usernameCount: $usernameCount, usernameLimit: $usernameLimit, defaultRecipientId: $defaultRecipientId, defaultAliasDomain: $defaultAliasDomain, defaultAliasFormat: $defaultAliasFormat, subscription: $subscription, subscriptionEndAt: $subscriptionEndAt, recipientCount: $recipientCount, recipientLimit: $recipientLimit, activeDomainCount: $activeDomainCount, activeDomainLimit: $activeDomainLimit, aliasCount: $aliasCount, aliasLimit: $aliasLimit, totalEmailsForwarded: $totalEmailsForwarded, totalEmailsBlocked: $totalEmailsBlocked, totalEmailsReplied: $totalEmailsReplied, totalEmailsSent: $totalEmailsSent, createdAt: $createdAt, lastUpdated: $lastUpdated}';
  }
}

extension AccountExtension on Account {
  bool get isSubscriptionFree =>
      subscription == AnonAddyString.subscriptionFree;

  bool get isSelfHosted => subscription.isEmpty;

  bool get hasRecipientsReachedLimit => recipientCount == recipientLimit;

  bool get hasUsernamesReachedLimit => usernameCount == usernameLimit;

  bool get hasDomainsReachedLimit => recipientCount == recipientLimit;
}
