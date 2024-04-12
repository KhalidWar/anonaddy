enum OnboardingPages {
  account(
    'assets/images/domains.svg',
    'Your Account. Your Way.',
    'With full offline support, access and manage your Addy.io (formerly AnonAddy) account, aliases, recipients, domains, and additional usernames from anywhere, any time.',
  ),
  aliases(
    'assets/images/aliases.svg',
    'Create Aliases',
    'Either on the fly or generated beforehand. Next time you are signing up to a website or newsletter, simply make up a new alias and enter that instead of your real email address.',
  ),
  recipients(
    'assets/images/recipients.svg',
    'Recipients',
    'Manage and easily add multiple recipients to go with new or existing aliases, as well as add your own GPG/OpenPGP public keys to recipients.',
  ),
  addyManager(
    'assets/images/api.svg',
    'Addy.io for mobile',
    'AddyManager is a standalone app independently built and maintained to help you access and manage your Addy.io account, and is not associated with the official Addy.io project or team.',
    showAddyManagerLinks: true,
  ),
  login(
    'assets/images/register.svg',
    'AddyManager. Secure. Private.',
    'AddyManager is free and open source, MIT-licensed software. Free as in free of ads, analytics, and trackers. What is yours is yours.',
    showDisclaimer: true,
  );

  const OnboardingPages(
    this.path,
    this.title,
    this.subtitle, {
    this.showAddyManagerLinks = false,
    this.showDisclaimer = false,
  });

  final String path;
  final String title;
  final String subtitle;
  final bool showAddyManagerLinks;
  final bool showDisclaimer;
}
