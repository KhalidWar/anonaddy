/// Alias
const kDeleteAliasString =
    'Deleted aliases reject all emails sent to them. However, they can be restored to start receiving emails again.';
const kDeleteAliasConfirmation =
    'Are you sure you want to delete this alias?\n\nYou can restore this alias if you later change your mind.\n\nOnce deleted, this alias will reject any emails sent to it.';
const kRestoreBeforeActivate =
    'You need to restore this alias before you can activate it';
const kCreateNewAliasString =
    'Other aliases e.g. alias@khalidwar.anonaddy.com or .me can also be created automatically when they receive their first email.';
const kRestoreAliasConfirmation =
    'Are you sure you want to restore this alias?\n\nOnce restored, this alias will be able to receive emails again.';
const kUpdateAliasRecipients =
    'Select the recipients for this alias. You can choose multiple recipients.\n\nLeave it empty if you would like to use the default recipient.';
const kForgetAliasConfirmation =
    'Are you sure you want to forget this alias?\n\nForgetting an alias will disassociate it from your account.\n\nNote: If this alias uses a shared domain then it can never be restored or used again so make sure you are certain. If it is a standard alias then it can be created again since it will be as if it never existed.';

/// Recipient
const kRemoveRecipientPublicKey = 'Remove recipient public key';
const kDeleteRecipientConfirmation =
    'Are you sure you want to delete this recipient?';
const kAddRecipientString =
    'Enter the individual email of the new recipient you\'d like to add.\n\nYou will receive an email with a verification link that will expire in one hour, you can click "Resend email" to get a new one.';
const kRemoveRecipientPublicKeyConfirmation =
    'Are you sure you want to remove the public key for this recipient?\n\nIt will also be removed from any other recipients using the same key.';
const kReachedRecipientLimit = 'You have reached your recipient limit';

/// Username
const kAddNewUsernameString =
    'Please choose additional usernames carefully as you can only add a maximum of three.\n\nYou cannot login with these usernames, only the one you originally signed up with.';
const kDeleteUsernameConfirmation =
    'Are you sure you want to delete this username?\n\nThis will also delete all aliases associated with this username.\n\nYou will no longer be able to receive any emails at this username subdomain.\n\nThis will still count towards your additional username limit even once deleted.';
const kReachedUsernameLimit = 'You have reached your additional username limit';
const kUpdateUsernameDefaultRecipient =
    'Select the default recipient for this username. This overrides the default recipient in your account settings.\n\nLeave it empty if you would like to use the default recipient in your account settings.';

/// Alias Format
const kUUID = 'uuid';
const kRandomChars = 'random_characters';
const kCustom = 'custom';
const kRandomWords = 'random_words';

/// Shared Domains
const kAnonAddyMe = 'anonaddy.me';
const kAddyMail = 'addymail.com';
const k4wrd = '4wrd.cc';
const kMailerMe = 'mailer.me';

/// AnonAddy Subscription Levels
const kFreeSubscription = 'free';
const kLiteSubscription = 'lite';
const kProSubscription = 'pro';
