import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  'Dara': ScreenArguments(
      "Dara",
      "13f1fcbeb57785f42fda7d4486b84d81ff6ad01379415fedd306c73",
      "darasmilelip@gmail.com"),
  'Richard': ScreenArguments(
      "Richard",
      "5971263380fde38969cbe536bd00315b7429feadfb6b9b2c2e44308754",
      "richard@mail.com"),
  'Toni': ScreenArguments("Toni",
      "9ae5b1946e613d9f15031630ed915dcaa987fcdce56ebb308755", "toni@mail.com"),
  'Setha': ScreenArguments(
      "Setha",
      "122fcba2fe35708bca9cd74cbc19bcd1e1a1818e5c825e99308756",
      "setha@mail.com"),
  'BoPark': ScreenArguments(
      "Bo Park",
      "f4a07186d59e8f3faab69e30ad2046b71b75d4da559dd11071e22308757",
      "bopark@mail.com"),
  'SoPheak': ScreenArguments(
      "SoPheak",
      "cbc5a041f4157984cdee96e71ab7a1712daa1443e5deee55308758",
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
      // case "444444":
      //   username = "Toni";
      //   break;
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
