import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class ScreenArguments {
  final String loggedUser;
  final String token;
  final String mail;

  ScreenArguments(this.loggedUser, this.token, this.mail);

  toMap() {
    return {"loggedUser": loggedUser, "token": token, "mail": mail};
  }
}

final Map users = {
  'Richard': ScreenArguments(
      "Richard",
      "6d2dc83bd8b8adcb6b6172db5394790f8fb7a257617407be3332bffa",
      "techemailfortesting@mail.com"),
  'Dara': ScreenArguments(
      "Dara",
      "c9a420287926a8bbcacebd4dc2f00a9669aa614623037fe2232bffd",
      "darasmilelip@gmail.com"),
  'Toni': ScreenArguments(
      "Toni",
      "27e0c6b85599c53aae5740abe1bbc4a7e343aed785bc09be4432bffe",
      "toni@mail.com"),
  'Setha': ScreenArguments(
      "Setha",
      "f4623d52359e20926c26491542f8663769edd9fa7d2772c568edd32bfff",
      "setha@mail.com"),
  'BoPark': ScreenArguments(
      "Bo Park",
      "79dca33a4294ed1382501ba5349aff78d9a7443325313e2232c001",
      "bopark@mail.com"),
  'SoPheak': ScreenArguments(
      "SoPheak",
      "fac2e872dc16eedb92bb4c68c2b896adc4bac5b4e94c6debb32c004",
      "sopheak@mail.com"),
};

class MyApp extends StatefulWidget {
  final User user;
  final String phoneNumber;

  MyApp({this.user, this.phoneNumber});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  static const platform = const MethodChannel("mesibo.flutter.io/messaging");
  static const EventChannel eventChannel =
      EventChannel('mesibo.flutter.io/mesiboEvents');
  String _mesiboStatus = 'Mesibo status: Not Connected.';

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  AnimationController loadingAnimation;

  @override
  void initState() {
    loadingAnimation = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1100));
    errorController = StreamController<ErrorAnimationType>();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    initializeMesiboScreen();
    super.initState();
  }

  void initializeMesiboScreen() async {
    await Future.delayed(Duration(milliseconds: 1000));
    await verify(code: widget.phoneNumber);
  }

  void _onEvent(Object event) {
    setState(() {
      _mesiboStatus = "" + event.toString();
    });
  }

  void _onError(Object error) {
    setState(() {
      _mesiboStatus = 'Mesibo status: unknown.';
    });
  }

  @override
  void dispose() {
    errorController.close();
    loadingAnimation.dispose();
    super.dispose();
  }

  Future<void> verify({code: String}) async {
    String username = "";
    switch (code) {
      case "+85561696308":
        username = "Dara";
        break;
      case "+855979796111":
        username = "Toni";
        break;
      case "333333":
        username = "BoPark";
        break;
      case "555555":
        username = "SoPheak";
        break;
      case "+85516205337":
        username = "Richard";
        break;
      default:
        username = "Setha";
    }
    List<Map> allUsers = [];
    users.forEach((k, v) => allUsers.add(v.toMap()));
    Map loggedUser = users[username].toMap();
    Navigator.pushNamed(context, "/home",
        arguments: ScreenArguments(
            loggedUser["loggedUser"], loggedUser["token"], loggedUser["mail"]));
    await platform.invokeMethod(
        "loginUser", {'loggedUser': loggedUser, 'allUsers': allUsers});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333808),
      body: Center(
        child: SpinKitFadingCircle(
          color: Colors.white,
        ),
      ),
    );
  }
}
