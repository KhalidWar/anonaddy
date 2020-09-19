# AnonAddy
Mobile app for [AnonAddy](https://anonaddy.com/). This app utilises [AnonAddy's API](https://app.anonaddy.com/docs/) to interact with user account.

## Disclaimer
This is a personal project and is **NOT** associated with [AnonAddy's project or team](https://github.com/anonaddy).

## Screenshots
<img src="assets/screenshots/2020-09-19 12.11.35.jpg" width="150"> <img src="assets/screenshots/2020-09-19 12.11.43.jpg" width="150"> <img src="assets/screenshots/2020-09-19 12.11.50.jpg" width="150">


## Features
- Get your AnonAddy's account details including usernames and aliases.
-  Create new aliases with only 2 taps, custom description input available.

### Upcoming Features
- Adaptive and persistive Light and Dark themes
- Activate/deactivate alias on the fly.


## Packages used
- [http](https://pub.dev/packages/http)
- [Provider](https://pub.dev/packages/provider)
- [Flutter SVG](https://pub.dev/packages/flutter_svg)


## Installation
Install by either sideloading attacked [APK file](https://github.com/KhalidWar/anonaddy/releases) on your android device or by building project from source following steps below.

### Getting Started
Check out [Flutter's official guide](https://flutter.dev/docs/get-started/install) to installing and running flutter.

### Prerequisites
- Download IDE either [Android Studio](https://developer.android.com/studio) or [VSC](https://code.visualstudio.com/)
- Install Flutter SDK and Dart plugin
- Emulator or physical device

### Steps
- Clone this repo to your machine: `https://github.com/KhalidWar/anonaddy.git`
- Create confidential.dart file under /lib/ directory
- Generate your own [Access Token](https://app.anonaddy.com/settings) under API section.
- Add a "bearerToken" const with your own access token string (e.g. const bearerToken = 'acccess_token_here';).
- Run on Emulator or physical device
- All set!

## License
This project is licensed under [MIT Licnese](https://github.com/KhalidWar/anonaddy/blob/master/LICENSE).

## Acknowledgement
- Special thanks to AnonAddy's team for providing us with their API and excellent documentation.