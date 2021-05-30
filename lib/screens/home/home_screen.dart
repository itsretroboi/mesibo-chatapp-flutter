import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_app/constants/constants.dart';
import 'package:flutter_test_app/models/users.dart';
import 'package:flutter_test_app/screens/auth/verify_otp_screen.dart';
import 'package:flutter_test_app/widgets/custom_alertdialog.dart';
import 'package:flutter_test_app/widgets/custom_drawerheader.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Home widget to display video chat option.
class HomeScreen extends StatefulWidget {
  static const platform = const MethodChannel("mesibo.flutter.io/messaging");

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController messageController = new TextEditingController();
  String phoneNumber = "";
  @override
  initState() {
    initializeHomeScreen();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showInfoDialog() {
    showDialog(
        context: context,
        builder: (ctx) => Center(
              child: CustomAlertDialog(
                title: "Info",
                icon: Icon(
                  Icons.info_outline,
                  size: 60.0,
                  color: Color(0xFF333808),
                ),
                details: "This is the demo version of RCAF Chat",
              ),
            ));
  }

  Future<void> initializeHomeScreen() async {
    await getPhoneNumber();
    messageController = TextEditingController(text: '');
  }

  Future<void> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneNumber = prefs.getString(PHONE_NUMBER);
    });
  }

  String getUserMail(String name) {
    String userMail = "darasmilelip@gmail.com";
    switch (name) {
      case "Dara":
        userMail = "darasmilelip@gmail.com";
        break;
      case "Toni":
        userMail = "toni@mail.com";
        break;
      case "Khun Sopheak":
        userMail = "sopheak@mail.com";
        break;
      case "Richard":
        userMail = "techemailfortesting@mail.com";
        break;
      case "Bo Park":
        userMail = "bopark@mail.com";
        break;
      case "Ly Setha":
        userMail = "setha@mail.com";
        break;
      case "Vansen":
        userMail = "vansenhengmeanrith@gmail.com";
    }
    return userMail;
  }

  void _launchMessagingUI(String user) async {
    await HomeScreen.platform.invokeMethod(
        "launchMessagingUI", {"remoteUser": this.getUserMail(user)});
  }

  void _audioCall(String user) async {
    await HomeScreen.platform
        .invokeMethod("audioCall", {"remoteUser": this.getUserMail(user)});
  }

  void _videoCall(String user) async {
    await HomeScreen.platform
        .invokeMethod("videoCall", {"remoteUser": this.getUserMail(user)});
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments arguments = ModalRoute.of(context).settings.arguments;
    String loggedUser = arguments.loggedUser;
    List<ChatUsers> users = [
      ChatUsers(
          userName: "Dara",
          profilePic: "assets/images/user1.jpg",
          phoneNumber: "+85587868278"),
      ChatUsers(
          userName: "Richard",
          profilePic: "assets/images/pichpanharith.jpeg",
          phoneNumber: "+85516205337"),
      ChatUsers(
          userName: "Bo Prak",
          profilePic: "assets/images/bongprak.jpeg",
          phoneNumber: "+85560551168"),
      ChatUsers(
          userName: "Ly Setha",
          profilePic: "assets/images/bongsetha.jpeg",
          phoneNumber: "+85512955408"),
      ChatUsers(
          userName: "Khun Sopheak",
          profilePic: "assets/images/bongpheak.jpeg",
          phoneNumber: "+85599988878"),
      ChatUsers(
          userName: "Toni",
          profilePic: "assets/images/bongtoni.jpeg",
          phoneNumber: "+855979796111"),
      ChatUsers(
          userName: "Vansen",
          profilePic: "assets/images/chris.jpeg",
          phoneNumber: "+85517701715"),
    ];
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF333808),
              ),
              child: CustomDrawerHeader(
                profileName: loggedUser,
                phoneNumber: phoneNumber,
                profilePic: users
                    .where((i) => i.userName == loggedUser)
                    .first
                    .profilePic,
              ),
            ),
            ListTile(
              title: Text(
                'Information',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              leading: Icon(Icons.info_outline, color: Colors.grey),
              onTap: () {
                _showInfoDialog();
              },
            ),
            ListTile(
              title: Text(
                'Log Out',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              leading: Icon(Icons.logout, color: Colors.grey),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/sign_up", (route) => false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          "RCAF Chat",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontSize: 21,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Color(0xFF333808),
      ),
      body: Center(
        child: Container(
          child: Column(children: [
            for (var user in users)
              if (user.userName != loggedUser)
                Card(
                  elevation: 5,
                  margin: EdgeInsets.zero,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.userName,
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          user.phoneNumber,
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.7)),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.call, color: Colors.blueGrey),
                          onPressed: () => _audioCall(user.userName),
                        ),
                        IconButton(
                          icon: Icon(Icons.video_call, color: Colors.blueGrey),
                          onPressed: () => _videoCall(user.userName),
                        ),
                      ],
                    ),
                    onTap: () => _launchMessagingUI(user.userName),
                    leading: CircleAvatar(
                      maxRadius: 25,
                      minRadius: 20,
                      backgroundImage: AssetImage(user.profilePic),
                    ),
                  ),
                ),
          ]),
        ),
      ),
    );
  }
}
