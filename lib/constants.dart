import 'package:flutter/material.dart';

// URLs
const String kBaseURL = 'https://app.anonaddy.com/api/v1';
const String kAccountDetailsURL = 'account-details';
const String kActiveAliasURL = 'active-aliases';
const String kAliasesURL = 'aliases';
const String kEncryptedRecipient = 'encrypted-recipients';
const String kRecipientsURL = 'recipients';
const String kRecipientKeys = 'recipient-keys';
const kGithubRepoURL = 'https://github.com/KhalidWar/anonaddy';
const kAnonAddySettingsAPIURL = 'https://app.anonaddy.com/settings';

// Official AnonAddy Strings
const kAboutAppText =
    'AddyManager is created by Khalid War as a tool to help you manage your AnonAddy account and is not associated with the official AnonAddy.com team or project. AddyManager is free and open-source. Free as in free of charge, free of ads, and free of trackers. \n\nPlease visit AddyManager\'s Github repository for more info.';
const kDeletedAliasText =
    'Deleted aliases reject all emails sent to them. However, they can be restored to start receiving emails again.';
const kDeleteAliasConfirmation =
    'Are you sure you want to delete this alias? You can restore this alias if you later change your mind. Once deleted, this alias will reject any emails sent to it.';
const kCreateNewAliasText =
    'Other aliases e.g. alias@khalidwar.anonaddy.com or .me can also be created automatically when they receive their first email.';
const kRestoreAliasText =
    'Are you sure you want to restore this alias? Once restored, this alias will be able to receive emails again.';
const kRemoveRecipientPublicKey = 'Remove recipient public key';
const kRemoveRecipientPublicKeyBody =
    'Are you sure you want to remove the public key for this recipient?\nIt will also be removed from any other recipients using the same key.';
const kDeleteRecipientDialogText =
    'Are you sure you want to delete this recipient?';
const kAddRecipientText =
    'Enter the individual email of the new recipient you\'d like to add.\n\nYou will receive an email with a verification link that will expire in one hour, you can click "Resend email" to get a new one.';

// Toast Messages
const kCopiedToClipboard = 'Copied to Clipboard';
const kAliasRestoredSuccessfully = 'Alias Restored Successfully';
const kFailedToRestoreAlias = 'Failed to Restore Alias';
const kAliasDeletedSuccessfully = 'Alias Deleted Successfully';
const kFailedToDeleteAlias = 'Failed to Delete Alias';
const kEncryptionEnabled = 'Encryption enabled';
const kFailedToEnableEncryption = 'Failed to Enable Encryption';
const kEncryptionDisabled = 'Encryption disabled';
const kFailedToDisableEncryption = 'Failed to disable encryption';
const kGPGKeyDeletedSuccessfully = 'GPG Key Deleted Successfully';
const kFailedToDeleteGPGKey = 'Failed to Delete GPG Key';
const kGPGKeyAddedSuccessfully = 'GPG Key Added Successfully';
const kFailedToAddGPGKey = 'Failed to Add GPG Key';

// UI Strings
const kSearchHintText = 'Search aliases, descriptions ...';
const kLoadingText = 'Loading';
const kDescriptionInputText = 'Description (optional)';
const kEnterLocalPart = 'Enter Local Part (no space or @)';
const kNoInternetConnection =
    'No Internet Connection.\nMake sure you\'re online.';
const kEditDescSuccessful = 'Description Updated Successfully';
const kEditDescFailed = 'Failed to update description';
const kGetAccessToken =
    'To access your AnonAddy account, you have to obtain an API Access Token.'
    '\n\nLogin to your AnonAddy account, head to settings, and navigate to API section.'
    '\n\nGenerate a new access token.'
    '\n\nAccess Token is a long string of alphabets, numbers, and special characters.'
    '\n\nPaste it here as is!';
const kPublicGPGKeyHintText =
    'Begins with \'-----BEGIN PGP PUBLIC KEY BLOCK-----\'';
const kEnterPublicKeyData =
    'Enter your PUBLIC key data in the text area below. Make sure to remove Comment: and Version:';
const kSignOutAlertDialog = 'Are you sure you want to sign out?';
const kUnverifiedRecipient =
    'Unverified recipient emails can NOT be set as default recipient for aliases.';

// Colors
const kBlueNavyColor = Color(0xFF19216C);
const kAccentColor = Color(0xFF62F4EB);

// UI Decoration
const kTextFormFieldDecoration = InputDecoration(
  border: OutlineInputBorder(),
  focusedBorder: OutlineInputBorder(),
);
