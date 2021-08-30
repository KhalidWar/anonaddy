/// Home Screen
const kAppBarTitle = 'AddyManager';
const kAccountBotNavLabel = 'Account';
const kAliasesBotNavLabel = 'Aliases';
const kSearchBotNavLabel = 'Search';

/// Aliases Tab
const kUpdateAliasRecipientNote =
    'Note: only verified recipients can be used as default recipients.';
const kDeleteAliasSubtitle = 'Alias will reject all emails sent to it';
const kRestoreAliasSubtitle = 'Alias will be able to receive emails';
const kUpdateDescriptionString =
    'Enter new description or enter empty whitespace remove current description';
const kForgetAlias = 'Forget Alias';
const kUpdateDescription = 'Update Description';
const kNoDefaultRecipientSet = 'No default recipient set yet';
const kSendFromAlias = 'Send From Alias';
const kSendFromAliasString =
    'Use this to automatically create the correct address to send an email to in order to send an email from this alias.';
const kSendFromAliasNote =
    'Note: you must send the email from a verified recipient on your account.';

/// Create Alias
const kCreateNewAlias = 'Create New Alias';
const kCreateAlias = 'Create Alias';
const kAliasDomain = 'Alias Domain';
const kAliasFormat = 'Alias Format';
const kSelectAliasDomain = 'Select Alias Domain';
const kSelectAliasFormat = 'Select Alias Format';
const kDescriptionFieldHint = 'Description (optional)';
const kLocalPartFieldHint = 'Enter Local Part (no space or @)';
const kCreateAliasWhileOffline = 'Can not create alias while offline';
const kCreateAliasCustomFieldNote = 'Note: not available on shared domains';

/// Recipient
const kPublicKeyFieldHint =
    'Begins with \'-----BEGIN PGP PUBLIC KEY BLOCK-----\'';
const kAddPublicKeyNote =
    'Enter your PUBLIC key data in the text area below. Make sure to remove Comment: and Version:';
const kUnverifiedRecipientNote =
    'Unverified recipient emails can NOT be set as default recipient for aliases.';

/// Domain
const kUnverifiedDomainWarning = 'Unverified domain';
const kInvalidDomainMXWarning =
    'Domain MX records are NOT validated or set correctly.';

/// Search Tab
const kSearchAliasByEmailOrDesc = 'Search for aliases by email or description';
const kSearchFieldHint = 'Search';
const kSearchHistory = 'Search History';

/// Login Screen
const kEnterAccessToken = 'Enter Access Token';
const kWhatsAccessToken = 'What is Access Token?';
const kAccessTokenDefinition =
    'Access Token is a long string of alphanumeric characters used to access an account without giving away the account\'s username and password.';
const kAccessTokenRequired =
    'To access your AnonAddy account, you\'ll have to provide your own Access Token.';
const kHowToGetAccessToken = 'How to get Access Token?';
const kHowToGetAccessToken1 = '1. Login to your AnonAddy account';
const kHowToGetAccessToken2 = '2. Go to Settings';
const kHowToGetAccessToken3 = '3. Scroll down to API section';
const kHowToGetAccessToken4 = '4. Click on Generate New Token';
const kHowToGetAccessToken5 = '5. Paste it as is in Login field';
const kAccessTokenSecurityNotice =
    'Security Notice: do NOT re-use Access Tokens. Make sure to generate a new token for every service you use.';
const kGetAccessToken = 'Get Access Token';

/// Error
const kLoadAccountDataFailed = 'Failed to Load Account Data';

/// Miscellaneous
const kLoadingText = 'Loading';
const kComingSoon = 'Coming Soon';
const kNoInternetConnection =
    'No Internet Connection.\nMake sure you\'re online.';
const kLogOutAlertDialog =
    'Are you sure you want to log out?\n\nAll app data will be deleted.';
const kNoDescription = 'No description';
const kSomethingWentWrong = 'Something went wrong';
const kFailedDeliveriesNote =
    'Sometimes when AnonAddy attempts to send an email, the delivery is not successful.\nThis is often referred to as a "bounced email".';
