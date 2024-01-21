import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageManager {
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', accessToken);
    prefs.setString('refreshToken', refreshToken);
  }

  Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      return accessToken;
    }
    return "";
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');
    if (refreshToken != null) {
      return refreshToken;
    }
    return null;
  }

  Future<void> updateAccessToken(String newAccessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', newAccessToken);
  }

  Future<bool> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedOutAccess = await prefs.remove('accessToken');
    final isLoggedOutRefresh = await prefs.remove('refreshToken');
    bool isLoggedOut = false;
    if (isLoggedOutAccess == true && isLoggedOutRefresh == true)
      isLoggedOut = true;
    return isLoggedOut;
  }

  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    return accessToken != "";
  }
}
