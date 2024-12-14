import 'package:app_mobile_42/helper/function.dart';
import 'package:app_mobile_42/services/auth_service.dart';
import 'package:app_mobile_42/services/http_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DataServices {
  static final DataServices _singleton = DataServices._internal();

  final _httpService = HttpServices();
  factory DataServices() {
    return _singleton;
  }
  DataServices._internal();

  Future<dynamic> getUserInfo() async {
    bool isvalid = await isTokenValid();
    if (isvalid == false) {
      String? token = await AuthService().refreshAccessToken();
      HttpServices().setup(bearerToken: token);
    }
    String path = "/v2/me";
    final response = await _httpService.get(path);
    if (response?.statusCode == 200 || response?.data != null ) {
      final data = response?.data;
      return data;
    }
    return null;
  }

  Future<dynamic> fetchTokenInfo() async {
    String path = "/oauth/token/info";
    try {
      final response = await _httpService.get(path);
      return response?.data;
    } catch (e) {
      print("Erreur de recuperation des informations du token");
      return null;
    }
  }

  
  Future<dynamic> getUserCoalition(int userId) async {
    String path = "/v2/users/$userId/coalitions";
    try {
      final response = await _httpService.get(path);
      return response?.data;
    } catch (e) {
      print("erreur lors de la recuperation de la coalition");
      return null;
    }
  }
  
  Future revokeToken(String token) async {
    String path = "/oauth/revoke";
    final String clientId = dotenv.env["API_42_CLIENT_ID"]!;
    final String clientSecret = dotenv.env["API_42_CLIENT_SECRET"]!;
    final response = await _httpService.post(path, {
      "token": token,
      "client_id": clientId,
      "client_secret": clientSecret
    });
    if (response?.statusCode == 200) {
      print("token revoqué avec succèss");
    }
    else {
      print("echec lors de la revoquation");
    }
  }
  Future<dynamic> getCursus(int userId) async {
    String path = "/v2/users/$userId/cursus_users";
    try {
      final response = await _httpService.get(path);
      if (response?.statusCode == 200 || response?.data != null) {
        return response?.data;
      }
    } catch (e) {
      print("echec de la recuperation du cursus");
      return null;
    }
  }
  Future<dynamic> getLocation(int userId) async {
    String path = "/v2/users/$userId/locations";
    try {
      final response =  await _httpService.get(path);
      if (response?.statusCode == 200 || response?.data != null) {
        return response?.data;
      }
    } catch (e) {
      print("Failed to get user location");
      return null;
    }
  }
}