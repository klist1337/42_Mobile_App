import 'package:app_mobile_42/helper/function.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();
  
  factory AuthService() { 
    return _singleton;
  }
  AuthService._internal();

  Future<AuthorizationTokenResponse?> authenticate() async {
  const FlutterAppAuth appAuth = FlutterAppAuth();

  String clientId = dotenv.env['API_42_CLIENT_ID']!;
  String clientSecret = dotenv.env['API_42_CLIENT_SECRET']!;
  const String redirectUrl = 'app://callback';
  const String issuer = 'https://api.intra.42.fr/oauth';
  const String authorizationEndpoint = "$issuer/authorize";
  const String tokenEndpoint = "$issuer/token";
  try {
     final result = await appAuth.authorizeAndExchangeCode(
    AuthorizationTokenRequest(
      clientId,
      redirectUrl,
      clientSecret: clientSecret,
      issuer: issuer,
      serviceConfiguration: const AuthorizationServiceConfiguration(
        authorizationEndpoint: authorizationEndpoint, 
        tokenEndpoint: tokenEndpoint),
      scopes: ['public','projects','profile'],
    ),
  );
  return result;
  } catch(e) {
    print(e);
  }
 
  }

  Future<String?> refreshAccessToken() async {
    final String? refreshToken = await getRefreshToken();
    const FlutterAppAuth appAuth = FlutterAppAuth();
    final String clientId = dotenv.env["API_42_CLIENT_ID"]!;
    const String redirectUrl = 'app://callback';
    final String clientSecret = dotenv.env['API_42_CLIENT_SECRET']!;
    const String issuer = 'https://api.intra.42.fr/oauth';
    const String authorizationEndpoint = "$issuer/authorize";
    const String tokenEndpoint = "$issuer/token";
    if (refreshToken != null) {
      try {
      final TokenResponse response = await appAuth.token(TokenRequest(
        clientId, 
        redirectUrl,
        clientSecret: clientSecret,
        issuer: issuer,
        refreshToken: refreshToken,
        serviceConfiguration: const AuthorizationServiceConfiguration(authorizationEndpoint: authorizationEndpoint, tokenEndpoint: tokenEndpoint)
        ));
        return response.accessToken;
    } catch (e) {
      print(e);
    }

      }
    return null;
  }

  
  
}
