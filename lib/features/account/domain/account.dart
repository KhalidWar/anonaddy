import 'package:anonaddy/common/constants/anonaddy_string.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
class Account {
  const Account({
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
    this.totalAliases = 0,
    this.totalActiveAliases = 0,
    this.totalInactiveAliases = 0,
    this.totalDeletedAliases = 0,
    this.activeRuleCount = 0,
    this.activeRuleLimit = 0,
    this.totalEmailsForwarded = 0,
    this.totalEmailsBlocked = 0,
    this.totalEmailsReplied = 0,
    this.totalEmailsSent = 0,
    required this.createdAt,
    required this.updatedAt,
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

  @JsonKey(name: 'total_aliases')
  final int totalAliases;

  @JsonKey(name: 'total_active_aliases')
  final int totalActiveAliases;

  @JsonKey(name: 'total_inactive_aliases')
  final int totalInactiveAliases;

  @JsonKey(name: 'total_deleted_aliases')
  final int totalDeletedAliases;

  @JsonKey(name: 'active_rule_count')
  final int activeRuleCount;

  @JsonKey(name: 'active_rule_limit')
  final int activeRuleLimit;

  @JsonKey(name: 'total_emails_forwarded')
  final int totalEmailsForwarded;

  @JsonKey(name: 'total_emails_blocked')
  final int totalEmailsBlocked;

  @JsonKey(name: 'total_emails_replied')
  final int totalEmailsReplied;

  @JsonKey(name: 'total_emails_sent')
  final int totalEmailsSent;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

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
          totalAliases == other.totalAliases &&
          activeRuleCount == other.activeRuleCount &&
          activeRuleLimit == other.activeRuleLimit &&
          totalEmailsForwarded == other.totalEmailsForwarded &&
          totalEmailsBlocked == other.totalEmailsBlocked &&
          totalEmailsReplied == other.totalEmailsReplied &&
          totalEmailsSent == other.totalEmailsSent &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

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
      totalAliases.hashCode ^
      activeRuleCount.hashCode ^
      activeRuleLimit.hashCode ^
      totalEmailsForwarded.hashCode ^
      totalEmailsBlocked.hashCode ^
      totalEmailsReplied.hashCode ^
      totalEmailsSent.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'Account{id: $id, username: $username, fromName: $fromName, emailSubject: $emailSubject, bannerLocation: $bannerLocation, bandwidth: $bandwidth, bandwidthLimit: $bandwidthLimit, usernameCount: $usernameCount, usernameLimit: $usernameLimit, defaultRecipientId: $defaultRecipientId, defaultAliasDomain: $defaultAliasDomain, defaultAliasFormat: $defaultAliasFormat, subscription: $subscription, subscriptionEndAt: $subscriptionEndAt, recipientCount: $recipientCount, recipientLimit: $recipientLimit, activeDomainCount: $activeDomainCount, activeDomainLimit: $activeDomainLimit, aliasCount: $aliasCount, aliasLimit: $aliasLimit, totalAliases: $totalAliases, activeRuleCount: $activeRuleCount, activeRuleLimit: $activeRuleLimit, totalEmailsForwarded: $totalEmailsForwarded, totalEmailsBlocked: $totalEmailsBlocked, totalEmailsReplied: $totalEmailsReplied, totalEmailsSent: $totalEmailsSent, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

extension AccountExtension on Account {
  bool get isSubscriptionFree => subscription == AddyString.subscriptionFree;

  bool get isSelfHosted => subscription.isEmpty;

  bool get hasRecipientsReachedLimit => recipientCount == recipientLimit;

  bool get hasUsernamesReachedLimit => usernameCount == usernameLimit;

  bool get hasDomainsReachedLimit => recipientCount == recipientLimit;

  bool get hasReachedRulesLimit => activeRuleCount == activeRuleLimit;
}
