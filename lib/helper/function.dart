
import 'package:app_mobile_42/services/data_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future saveToken(String accessToken, String refreshToken) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("accessToken", accessToken);
  prefs.setString("refreshToken", refreshToken);
  prefs.setBool("isConnected", true);
}

Future<bool> isConnected() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isConnected") ?? false;
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("accessToken");
}

Future<String?> getRefreshToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("refreshToken");
}

Future deleToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString("accessToken");
  await DataServices().revokeToken(token!);
  prefs.clear();
}

Future<bool> isTokenValid() async {
    final response = await DataServices().fetchTokenInfo();
    if (response == null) {
      return false;
    }
    if (response["expires_in_seconds"] == null || response["expires_in_seconds"] <= 50) {
      return false;
    }
    return true;
  }
