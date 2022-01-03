import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future createCache(String walletAddresses,String walletEncryptedKey) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString("walletAddress", walletAddresses);
    _preferences.setString("walletEncryptedKey", walletAddresses);
  }

  Future<Map<String, String?>> readCache() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var walletAddress = _preferences.getString("walletAddress");
    var walletEncryptedKey = _preferences.getString("walletEncryptedKey");
    Map<String, String?> map = {
      'walletAddress': walletAddress,
      'walletEncryptedKey': walletEncryptedKey,
    };

    return map;
  }

  Future removeCache() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove("walletAddress");
    _preferences.getString("walletEncryptedKey");
  }
}