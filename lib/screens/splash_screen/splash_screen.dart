import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/constants/constants.dart';
import 'package:flutter_test_app/providers/app_provider.dart';
import 'package:flutter_test_app/screens/auth/signup_screen.dart';
import 'package:flutter_test_app/screens/auth/verify_otp_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:path_provider/path_provider.dart';

class SplashScreenCustom extends StatefulWidget {
  @override
  _SplashScreenCustomState createState() => _SplashScreenCustomState();
}

class _SplashScreenCustomState extends State<SplashScreenCustom> {
  @override
  void initState() {
    runAppInitialization();
    super.initState();
  }

  Future<void> setExternalDirectory() async {
    Directory platformDirectory;
    final prefs = await SharedPreferences.getInstance();

    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    if (Platform.isAndroid) {
      platformDirectory = await getExternalStorageDirectory();
    } else {
      platformDirectory = await getApplicationDocumentsDirectory();
      print(Platform.operatingSystem + "&" + platformDirectory.path);
    }
    await prefs.setString("ROOT_PATH", platformDirectory.path);
    await Future.delayed(const Duration(milliseconds: 1000));
    appProvider.rootPath = prefs.getString("ROOT_PATH");
  }

  Future<void> determineInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String validUser = prefs.getString(VALID_USER) ?? '';
    // String phoneNumber = prefs.getString(PHONE_NUMBER) ?? '';
    // FirebaseAuth _auth = FirebaseAuth.instance;

    if (validUser.isEmpty) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/sign_up', (route) => false);
      // Until here
      //   Navigator.of(context).pushNamedAndRemoveUntil('/otp', (route) => false,
      //       arguments: {"phoneNumber": "+85516205337"});
      // } else {
      // _auth.verifyPhoneNumber(
      //     phoneNumber: phoneNumber,
      //     timeout: Duration(seconds: 60),
      //     verificationCompleted: (AuthCredential authCredential) {
      //       _auth
      //           .signInWithCredential(authCredential)
      //           .then((UserCredential result) {
      //         Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) =>
      //                     PinCodeVerificationScreen(user: result.user)));
      //       }).catchError((e) {
      //         print('==========');
      //         print(e);
      //       });
      //     },
      //     verificationFailed: null,
      //     codeSent: null,
      //     codeAutoRetrievalTimeout: null);
    }
  }

  void runAppInitialization() async {
    AppProvider appProvider = Provider.of(context, listen: false);
    appProvider.setAppOrientation();
    await Future.delayed(const Duration(milliseconds: 4600));
    await appProvider.requestPermissions();
    await setExternalDirectory();
    await determineInitialRoute();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/images/rotate-logo.gif",
          scale: 0.6,
        ),
      ),
    );
  }
}
