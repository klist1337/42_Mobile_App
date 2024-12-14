import 'package:app_mobile_42/helper/function.dart';
import 'package:app_mobile_42/home_page.dart';
import 'package:app_mobile_42/login_page.dart';
import 'package:app_mobile_42/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  String accessToken = await getToken() ?? "";
  bool connected = await isConnected();
  //bool isValid = await isTokenValid();
  await HttpServices().setup(bearerToken: accessToken);
  runApp(MyApp(isConnected: connected, accessToken: accessToken,));
}

class MyApp extends StatelessWidget {
  const MyApp({
  super.key, 
  required this.isConnected, 
  required this.accessToken,
  });
  final bool isConnected;
  final String accessToken;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'futura-pt',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  !isConnected || accessToken.isEmpty ? const Loginpage() : const HomePage() ,
      //home: const Loginpage(),
    );
  }
}
