import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/constants/constants.dart';
import 'package:flutter_test_app/screens/auth/verify_otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({this.phoneNumber});

  final String phoneNumber;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _smsVerificationCode = TextEditingController();
  String _verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Timer _timer;
  int _start = 70;

  @override
  void initState() {
    _verifyPhoneAuth(widget.phoneNumber, _scaffoldKey.currentContext);
    startTimer();
    super.initState();
  }

  void _signInPhoneAuth(String _smsCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsCode,
      );
      _auth.signInWithCredential(authCredential).then((UserCredential result) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyApp(
                      phoneNumber: widget.phoneNumber,
                    )));
        prefs.setString(PHONE_NUMBER, widget.phoneNumber);
      }).catchError((e) {
        print('==========');
        print(e);
      });
      print("Successfully signed in}");
    } catch (e) {
      print("Failed to sign in: " + e.toString());
    }
  }

  void _verifyPhoneAuth(String phoneNumber, BuildContext context) {
    print("Verify Phone Number");
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) async {
          await _auth.signInWithCredential(authCredential);
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(
              'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          print("VerificationID" + verificationId);
        });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
            "Phone Verification",
            style: TextStyle(
                // color: Color(0xFFE3BD00),
                color: Colors.white,
                fontFamily: "Roboto",
                fontSize: 21,
                fontWeight: FontWeight.w500),
          ),
          backgroundColor: Color(0xFF333808),
          leading: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24.0,
            ),
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Image(
              image: AssetImage('assets/icons/sms.png'),
              width: 75,
              height: 75,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Enter Verification Code",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Text(
                "We've sent an SMS with an activation code to your phone \b${widget.phoneNumber}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey, fontSize: 14, fontFamily: "Roboto")),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            child: PinInputTextField(
              decoration: UnderlineDecoration(
                  textStyle: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF333808),
                      fontSize: 24),
                  colorBuilder: PinListenColorBuilder(
                      Color(0xFF333808), Color(0xFF333808))),
              pinLength: 6,
              controller: _smsVerificationCode,
              onSubmit: (value) {
                _signInPhoneAuth(value);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: TextButton(
                onPressed: () {
                  _signInPhoneAuth(_smsVerificationCode.text.toString());
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color(0xFF333808))),
                child: Text("Confirm",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.white))),
          ),
          Text("The Code Expires in: $_start",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey, fontSize: 14, fontFamily: "Roboto"))
        ],
      ),
    );
  }
}
