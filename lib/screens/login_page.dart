import 'package:app_mobile_42/helper/function.dart';
import 'package:app_mobile_42/screens/home_page.dart';
import 'package:app_mobile_42/services/auth_service.dart';
import 'package:app_mobile_42/services/http_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_svg/svg.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/bkgrnd.jpg'))
        ),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.3),
            SvgPicture.asset('assets/images/42_logo.svg',
              width: 80,
              height: 80,),
            const SizedBox(height: 100,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const LinearBorder(),
                backgroundColor: const Color(0xFF00BABC)
              ),
              onPressed: () async {
              final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
              if (connectivityResult.contains(ConnectivityResult.none)) {
                if (!context.mounted) return;
                showConnectionErrorSnackBar(context);
              }
              else {
                try {
                  final AuthorizationTokenResponse? result = await AuthService().authenticate();
                    if (result != null) {
                      await saveToken(result.accessToken!, result.refreshToken!);
                      await HttpServices().setup(bearerToken: result.accessToken);
                      if (!context.mounted) return;
                      Navigator.pushReplacement(context, 
                      MaterialPageRoute(builder: (context) =>
                      const HomePage()));
                    }
                  } on FlutterAppAuthUserCancelledException catch (e) {
                    return;
                  }
                  catch(e) {
                    return;
                  }
                }            
              }, 
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0),
              child: Text('Login',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),),
            )
            ),
          ],
        ),
      ),
    );
  }
  void showConnectionErrorSnackBar(BuildContext context) {
     final snackBar = SnackBar(
      content: const Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.white,),
          SizedBox(width: 10,),
          Text("No connection"),
        ],),
        backgroundColor: Colors.redAccent,
        elevation: 10,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: "RETRY", onPressed: () {}),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}