import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/screens/auth/signup_ui.dart';
import 'verify_otp_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  _onSignUpPressed(String phoneNumber, BuildContext context) async {
    Navigator.of(context)
        .pushNamed('/otp', arguments: {"phoneNumber": phoneNumber});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AuthUI(
        phoneNumberController: _phoneNumberController,
        onSignUpPresssed: _onSignUpPressed,
      ),
    );
  }
}
