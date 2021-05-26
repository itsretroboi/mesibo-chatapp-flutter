import 'package:flutter/material.dart';
import 'package:flutter_test_app/screens/auth/otp_screen.dart';
import 'package:flutter_test_app/screens/auth/verify_otp_screen.dart';
import 'package:flutter_test_app/screens/home/home_screen.dart';
import 'package:flutter_test_app/screens/auth/login_screen.dart';
import 'package:flutter_test_app/screens/auth/signup_screen.dart';
import 'package:flutter_test_app/screens/splash_screen/splash_screen.dart';

class AppController extends StatelessWidget {
  final Map<String, Widget> routes = {
    "/": SplashScreenCustom(),
    "/sign_up": AuthScreen(),
    "/home": HomeScreen(),
    "/login": LoginScreen()
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey,
        accentColor: Colors.cyan[600],
      ),
      onGenerateRoute: (RouteSettings settings) {
        Route screen;
        switch (settings.name) {
          case "/otp":
            {
              Map<String, dynamic> args = settings.arguments;
              String phoneNumber = args['phoneNumber'];
              screen = MaterialPageRoute(
                settings: settings,
                builder: (_) => OtpScreen(
                  phoneNumber: phoneNumber,
                ),
              );
              break;
            }
          default:
            {
              screen = MaterialPageRoute(
                settings: settings,
                builder: (BuildContext context) {
                  return routes[settings.name];
                },
              );
              break;
            }
        }
        return screen;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
