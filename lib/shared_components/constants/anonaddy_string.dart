///
/// Collection of official addy.io UI strings extracted from addy.io
class AddyString {
  /// Alias
  static const deleteAliasString =
      'Deleted aliases reject all emails sent to them. However, they can be restored to start receiving emails again.';
  static const deleteAliasConfirmation =
      'Are you sure you want to delete this alias?\n\nYou can restore this alias if you later change your mind.\n\nOnce deleted, this alias will reject any emails sent to it.';
  static const restoreBeforeActivate =
      'Restore this alias before you can activate it';
  static const createNewAliasString =
      'Other aliases e.g. alias@khalidwar.addy.id or .me can also be created automatically when they receive their first email.';
  static const restoreAliasConfirmation =
      'Are you sure you want to restore this alias?\n\nOnce restored, this alias will be able to receive emails again.';
  static const updateAliasRecipients =
      'Select the recipients for this alias. You can choose multiple recipients.\n\nLeave it empty if you would like to use the default recipient.';
  static const forgetAliasConfirmation =
      'Are you sure you want to forget this alias?\n\nForgetting an alias will disassociate it from your account.\n\nNote: If this alias uses a shared domain then it can never be restored or used again so make sure you are certain. If it is a standard alias then it can be created again since it will be as if it never existed.';

  /// Recipient
  static const removeRecipientPublicKey = 'Remove recipient public key';
  static const deleteRecipientConfirmation =
      'Are you sure you want to delete this recipient?';
  static const addRecipientString =
      'Enter the individual email of the new recipient you\'d like to add.\n\nYou will receive an email with a verification link that will expire in one hour, you can click "Resend email" to get a new one.';
  static const removeRecipientPublicKeyConfirmation =
      'Are you sure you want to remove the public key for this recipient?\n\nIt will also be removed from any other recipients using the same key.';
  static const reachedRecipientLimit = 'You have reached your recipient limit';
  static const reachedDomainLimit = 'You have reached your domain limit';
  static const reachedRulesLimit = 'You have reached your rules limit';

  /// Username
  static const addNewUsernameString =
      'Please choose additional usernames carefully as you can only add a maximum of three.\n\nYou cannot login with these usernames, only the one you originally signed up with.';
  static const deleteUsernameConfirmation =
      'Are you sure you want to delete this username?\n\nThis will also delete all aliases associated with this username.\n\nYou will no longer be able to receive any emails at this username subdomain.\n\nThis will still count towards your additional username limit even once deleted.';
  static const reachedUsernameLimit =
      'You have reached your additional username limit';
  static const updateUsernameDefaultRecipient =
      'Select the default recipient for this username. This overrides the default recipient in your account settings.\n\nLeave it empty if you would like to use the default recipient in your account settings.';

  /// Domain
  static const deleteDomainConfirmation =
      'Are you sure you want to delete this domain?\n\nThis will also delete all aliases associated with this domain.\n\nYou will no longer be able to receive any emails at this domain.';
  static const updateDomainDefaultRecipient =
      'Select the default recipient for this domain. This overrides the default recipient in your account settings.\n\nLeave it empty if you would like to use the default recipient in your account settings.';

  /// Alias Format
  static const aliasFormatUUID = 'uuid';
  static const aliasFormatRandomChars = 'random_characters';
  static const aliasFormatCustom = 'custom';
  static const aliasFormatRandomWords = 'random_words';

  /// addy.io Subscription Levels
  static const subscriptionFree = 'free';
  static const subscriptionLite = 'lite';
  static const subscriptionPro = 'pro';

  /// Subscription Notices
  static const kSubscriptionInfoText =
      'You must be subscribed to unlock this feature';
}
