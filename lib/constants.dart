import 'package:flutter/material.dart';

// URLs
const String kBaseURL = 'https://app.anonaddy.com/api/v1';
const String kAccountDetailsURL = 'account-details';
const String kActiveAliasURL = 'active-aliases';
const String kAliasesURL = 'aliases';

// Official AnonAddy Strings
const kAboutAppText =
    'This app is a part of Khalid War\'s personal projects. It\'s free and open source. Free as in free of charge, free of ads, and free of trackers. \n\nTo check out the source code for this app, please visit our github repo.';
const kDeletedAliasText =
    'Deleted aliases reject all emails sent to them. However, they can be restored to start receiving emails again.';
const kDeleteAliasConfirmation =
    'Are you sure you want to delete this alias? You can restore this alias if you later change your mind. Once deleted, this alias will reject any emails sent to it.';
const kCreateNewAliasText =
    'Other aliases e.g. alias@khalidwar.anonaddy.com or .me can also be created automatically when they receive their first email.';
const kRestoreAliasText =
    'Are you sure you want to restore this alias? Once restored, this alias will be able to receive emails again.';

// Toast Messages
const kCopiedToClipboard = 'Copied to Clipboard';
const kAliasRestoredSuccessfully = 'Alias Restored Successfully';
const kFailedToRestoreAlias = 'Failed to Restore Alias';
const kAliasDeletedSuccessfully = 'Alias Deleted Successfully';
const kFailedToDeleteAlias = 'Failed to Delete Alias';

// UI Strings
const kSearchHintText = 'Search aliases, descriptions ...';
const kFetchingDataText = 'Fetching data...';
const kDescriptionInputText = 'description (optional)';
const kNoInternetConnection =
    'No Internet Connection.\nMake sure you\'re online.';

// Colors
const kBlueNavyColor = Color(0xFF19216C);
const kAccentColor = Color(0xFF62F4EB);
