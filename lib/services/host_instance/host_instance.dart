import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum Instance { AnonAddy, SelfHosted }

class HostInstance {
  final _secureStorage = FlutterSecureStorage();
  final _hostInstanceKey = 'hostInstanceKey';

  Instance instance;
  String _instanceURL;

  Future<void> setHostInstance(String url) async {
    if (url == null) {
      instance = Instance.AnonAddy;
      _instanceURL = kAuthorityURL;
      await _secureStorage.write(key: _hostInstanceKey, value: _instanceURL);
    } else {
      instance = Instance.SelfHosted;
      _instanceURL = url;
      await _secureStorage.write(key: _hostInstanceKey, value: url);
    }
  }

  Future<Instance> getHostInstance() async {
    String savedURL;
    if (_instanceURL == null) {
      savedURL = await _secureStorage.read(key: _hostInstanceKey);
      if (savedURL == kAuthorityURL) {
        instance = Instance.AnonAddy;
        return Instance.AnonAddy;
      } else {
        instance = Instance.SelfHosted;
        return Instance.SelfHosted;
      }
    } else {
      return instance;
    }
  }

  Future<String> getInstanceURL() async {
    if (_instanceURL == null) {
      _instanceURL = await _secureStorage.read(key: _hostInstanceKey);
      return _instanceURL;
    } else {
      return _instanceURL;
    }
  }
}
