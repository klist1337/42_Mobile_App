import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();
  
  factory AuthService() { 
    return _singleton;
  }
  AuthService._internal();

  Future<String?> authenticate() async {
  const FlutterAppAuth appAuth = FlutterAppAuth();

  String clientId = dotenv.env['API_42_CLIENT_ID']!;
  String clientSecret = dotenv.env['API_42_CLIENT_SECRET']!;
  const String redirectUrl = 'app://callback';
  const String issuer = 'https://api.intra.42.fr/oauth';
  const String authorizationEndpoint = "$issuer/authorize";
  const String tokenEndpoint = "$issuer/token";

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
  return result.accessToken;
  }
}
