/// Collection of all text in UI used in app.
class AppStrings {
  /// Home Screen
  static const appName = 'AddyManager';
  static const accountBotNavLabel = 'Account';
  static const aliasesBotNavLabel = 'Aliases';
  static const searchBotNavLabel = 'History';

  /// Account Tab
  static const account = 'Account';
  static const recipients = 'Recipients';
  static const usernames = 'Usernames';
  static const domains = 'Domains';
  static const rules = 'Rules';
  static const aliases = 'Aliases';
  static const selfHosted = 'Self Hosted';
  static const subscriptionEndDate = 'Subscription End Date';
  static const accessTokenInfo = 'Access Token Info';
  static const subscriptionEndDateNotAvailable = 'Not available';
  static const subscriptionEndDateDoesNotExpire = 'does not expire';
  static const noSubscription = 'no subscription';
  static const noDefaultSelected = 'No default selected';
  static const defaultAliasFormat = 'Default Alias Format';
  static const defaultAliasDomain = 'Default Alias Domain';
  static const unlimited = 'unlimited';
  static const addNewRecipient = 'Add Recipient';

  /// Aliases Tab
  static const updateAliasRecipientNote =
      'Only verified recipients can be used as default recipients.';
  static const deleteAliasSubtitle = 'Alias will reject all emails sent to it';
  static const restoreAliasSubtitle = 'Alias will be able to receive emails';
  static const updateDescriptionString =
      'Provide a unique memorable description';
  static const forgetAlias = 'Forget Alias';
  static const updateDescriptionTitle = 'Update Description';
  static const removeDescriptionTitle = 'Remove Description';
  static const noDefaultRecipientSet = 'No default recipient set yet';
  static const sendFromAlias = 'Send From Alias';
  static const sendFromAliasString =
      'Use this to automatically create the correct address to send an email to in order to send an email from this alias.';
  static const sendFromAliasNote =
      'Note: you must send the email from a verified recipient on your account.';
  static const actions = 'Actions';
  static const description = 'Description';

  /// Create Alias
  static const createNewAlias = 'Create New Alias';
  static const createAliasTitle = 'Create Alias';
  static const aliasDomainTitle = 'Alias Domain';
  static const aliasFormat = 'Alias Format';
  static const selectAliasDomain = 'Select Alias Domain';
  static const selectAliasFormat = 'Select Alias Format';
  static const descriptionFieldHint = 'Description (optional)';
  static const localPartFieldHint = 'Enter Local Part (no space or @)';
  static const createAliasWhileOffline = 'Can not create alias while offline';
  static const createAliasCustomFieldNote =
      'Note: not available on shared domains';

  /// Recipients
  static const publicKeyFieldHint =
      'Begins with \'-----BEGIN PGP PUBLIC KEY BLOCK-----\'';
  static const addPublicKeyNote =
      'Enter your PUBLIC key data in the text area below. Make sure to remove Comment: and Version:';
  static const unverifiedRecipientNote =
      'Unverified recipient emails can NOT be set as default recipient for aliases.';
  static const noRecipientsFound = 'No recipients found';
  static const verified = 'Verified';
  static const unverified = 'Unverified';
  static const disableInlineEncryptionFirst =
      'You need to disable inline encryption before you can enable protected headers (hide subject)';
  static const disableProtectedHeadersFirst =
      'You need to disable protected headers (hide subject) before you can enable inline encryption';

  /// Usernames
  static const addNewDomain = 'Add Domain';
  static const addNewUsername = 'Add Username';
  static const addUsername = 'Add Username';
  static const noAdditionalUsernamesFound = 'No usernames found';

  /// Domain
  static const unverifiedDomainWarning = 'Unverified domain';
  static const invalidDomainMXWarning =
      'Domain MX records are NOT validated or set correctly.';
  static const noDomainsFound = 'No domains found';

  /// Rules
  static const noRulesFound = 'No rules found';
  static const enrollRulesBetaTesting = 'Enroll in Rules BETA testing';
  static const addNewRule = 'Add Rule';

  /// Search Tab
  static const quickSearch = 'Quick Search';
  static const searchAliasByEmailOrDesc =
      'Search for aliases by email or description';
  static const searchFieldHint = 'Search';
  static const searchHistory = 'Search History';
  static const clearSearchHistoryButtonText = 'Clear';
  static const searching = 'Searching...';
  static const cancelSearchingButtonText = 'Cancel';
  static const searchResult = 'Search Result';
  static const limitedSearchResult = 'Limited Result';
  static const closeSearchButtonText = 'Close Search';

  /// Settings Screen
  static const settings = 'Settings';
  static const settingsDarkTheme = 'Dark Theme';
  static const settingsDarkThemeSubtitle = 'App follows system by default';
  static const settingsAutoCopyEmail = 'Auto Copy Email';
  static const settingsAutoCopyEmailSubtitle =
      'Automatically copy email after alias creation';
  static const settingsBiometricAuth = 'Biometric Authentication';
  static const settingsBiometricAuthSubtitle =
      'Require biometric authentication';
  static const settingsAddyHelpCenter = 'Addy.io Help Center';
  static const settingsAddyHelpCenterSubtitle =
      'Addy.io\'s terminologies...etc.';
  static const settingsAddyFAQ = 'Addy.io FAQ';
  static const settingsAddyFAQSubtitle = 'Learn more about addy.io';
  static const settingsAboutApp = 'About AddyManager';
  static const settingsAboutAppSubtitle =
      'App version, links, privacy report, etc.';
  static const settingsEnjoyingApp = 'Enjoying AddyManager?';
  static const settingsEnjoyingAppSubtitle = 'Tap to rate it on the App Store';
  static const settingsLogout = 'Logout';
  static const settingsLogoutSubtitle = 'All app data will be deleted';
  static const appVersion = 'Your self-hosted instance version';

  /// Alert Center
  static const alertCenter = 'Alert Center';
  static const notifications = 'Notifications';
  static const notificationsNote =
      'One central location for your account alerts and notifications.';
  static const failedDeliveries = 'Failed deliveries';
  static const failedDeliveriesNote =
      'Sometimes when addy.io attempts to send an email, the delivery is not successful. This is often referred to as a "bounced email".';

  /// Login Screen
  static const enterAccessToken = 'Enter Access Token';
  static const whatsAccessToken = 'What is Access Token?';
  static const accessTokenRequired =
      'To access your Addy.io account, you\'ll have to provide your own Access Token which is a long string of alphanumeric characters used to access an account without giving away the account\'s username and password.';
  static const howToGetAccessToken = 'How to get Access Token?';
  static const howToGetAccessToken1 = '1. Login to your Addy.io account';
  static const howToGetAccessToken2 = '2. Go to Settings';
  static const howToGetAccessToken3 = '3. Scroll down to API section';
  static const howToGetAccessToken4 = '4. Click on Generate New Token';
  static const howToGetAccessToken5 = '5. Copy the generated access token';
  static const accessTokenSecurityNotice =
      'Security Notice: do NOT re-use Access Tokens. Make sure to generate a new token for every service you use.';
  static const getAccessToken = 'Get Access Token';
  static const enterYourApiToken = 'Enter your API token';

  /// Errors
  static const loadAccountDataFailed = 'Failed to Load Account Data';
  static const somethingWentWrong = 'Something went wrong';
  static const failedToLaunchUrl = 'Failed to launch URL';
  static const deviceDoesNotSupportBioAuth =
      'Device doesn\'t support biometric authentication';
  static const failedToAuthenticate = 'Failed to authenticate';

  /// Button Labels
  static const doneText = 'Done';
  static const cancelText = 'Cancel';

  /// No Internet (Offline Mode) Dialog
  static const noInternetOfflineData = 'No internet connection';
  static const noInternetDialogTitle = 'Offline Mode';
  static const noInternetContent =
      'No internet connection; displaying cached offline data.';
  static const noInternetDialogButton = 'Close';

  /// Miscellaneous
  static const loadingText = 'Loading';
  static const comingSoon = 'Coming Soon';
  static const logOutAlertDialog =
      'Are you sure you want to log out?\n\nAll app data will be deleted.';
  static const noDescription = 'No description';
  static const navigationErrorMessage =
      'Something has gone wrong with the navigation system.\n\nPlease go back and try again.';

  /// Form validation error messages
  static const provideValidAccessToken = 'Provide a valid Access Token';
  static const usernameIsRequired = 'Username is required';
  static const fieldCannotBeEmpty = 'Field can not be empty';
  static const enterValidEmail = 'Enter a valid email';
  static const provideValidLocalPart = 'Provide a valid local part';
  static const providerValidUrl = 'Provide a valid URL';
  static const keywordMustBe3CharsLong = 'Keyword must be 3 characters long';

  /// Monetization
  static const failedToLoadSubscriptionData =
      'Failed to load subscription data';
}
