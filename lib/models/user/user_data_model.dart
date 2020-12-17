// class UserModel {
//   UserModel({
//     this.userDataList,
//   });
//
//   List<UserDataModel> userDataList;
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     List list = json['data'];
//     List<UserDataModel> aliasDataList =
//         list.map((i) => UserDataModel.fromJson(i)).toList();
//
//     return UserModel(
//       userDataList: aliasDataList,
//     );
//   }
// }
//
// class UserDataModel {
//   const UserDataModel({
//     this.id,
//     this.username,
//     this.fromName,
//     this.emailSubject,
//     this.bannerLocation,
//     this.bandwidth,
//     this.usernameCount,
//     this.usernameLimit,
//     this.defaultRecipientId,
//     this.defaultAliasDomain,
//     this.defaultAliasFormat,
//     this.subscription,
//     this.bandwidthLimit,
//     this.recipientCount,
//     this.recipientLimit,
//     this.activeDomainCount,
//     this.activeDomainLimit,
//     this.activeSharedDomainAliasCount,
//     this.activeSharedDomainAliasLimit,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   final String id;
//   final String username;
//   final String fromName;
//   final String emailSubject;
//   final String bannerLocation;
//   final int bandwidth;
//   final int usernameCount;
//   final int usernameLimit;
//   final String defaultRecipientId;
//   final String defaultAliasDomain;
//   final String defaultAliasFormat;
//   final String subscription;
//   final int bandwidthLimit;
//   final int recipientCount;
//   final int recipientLimit;
//   final int activeDomainCount;
//   final int activeDomainLimit;
//   final int activeSharedDomainAliasCount;
//   final int activeSharedDomainAliasLimit;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
//         id: json["id"],
//         username: json["username"],
//         fromName: json["from_name"],
//         emailSubject: json["email_subject"],
//         bannerLocation: json["banner_location"],
//         bandwidth: json["bandwidth"],
//         usernameCount: json["username_count"],
//         usernameLimit: json["username_limit"],
//         defaultRecipientId: json["default_recipient_id"],
//         defaultAliasDomain: json["default_alias_domain"],
//         defaultAliasFormat: json["default_alias_format"],
//         subscription: json["subscription"],
//         bandwidthLimit: json["bandwidth_limit"],
//         recipientCount: json["recipient_count"],
//         recipientLimit: json["recipient_limit"],
//         activeDomainCount: json["active_domain_count"],
//         activeDomainLimit: json["active_domain_limit"],
//         activeSharedDomainAliasCount: json["active_shared_domain_alias_count"],
//         activeSharedDomainAliasLimit: json["active_shared_domain_alias_limit"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );
// }
