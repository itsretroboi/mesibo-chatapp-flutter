import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUI extends StatelessWidget {
  AuthUI({
    this.phoneNumberController,
    this.onSignUpPresssed,
  });
  final TextEditingController phoneNumberController;
  final Function onSignUpPresssed;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    List<String> specialNumbers = [
      //Bong Sopheak
      "+85599988878",
      //Bong Prak
      "+85560551168",
      //Richard
      "+85516205337",
      //Dara
      "+85587868278",
      //Bong Setha
      "+85512955408",
      //Bong Toni
      "+855979796111",
      //Vansen
      "+85517701715"
    ];
    void _showToast(BuildContext context, String alertMsg) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 750),
          content: Text(alertMsg),
        ),
      );
    }

    Future<bool> isSpecial(String phoneNumber) async {
      final prefs = await SharedPreferences.getInstance();
      if (specialNumbers.contains(phoneNumber)) {
        prefs.setString(PHONE_NUMBER, phoneNumber);
        return true;
      } else {
        return false;
      }
    }

    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment(1, 0.4),
        child: FloatingActionButton(
          heroTag: "Login",
          backgroundColor: Color(0xFF333808),
          onPressed: () async {
            final String phoneNumber =
                "+855" + phoneNumberController.text.toString();
            if (phoneNumberController.text.isEmpty) {
              _showToast(context, "Phone Number Can't Be Empty");
            } else {
              if (isNumeric(phoneNumberController.text.toString()) == false) {
                _showToast(context, "Not A Valid Phone Number");
              } else {
                if (await isSpecial(phoneNumber) == true) {
                  onSignUpPresssed(phoneNumber, context);
                } else {
                  _showToast(context, "Please Contact Your Admin To Register");
                }
              }
            }
          },
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 24.0,
          ),
        ),
      ),
      appBar: AppBar(
          title: Text(
            "Your Phone",
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
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, right: 25.0, left: 25.0),
            margin: EdgeInsets.only(top: 25.0),
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "+855",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: "Roboto"),
                    )),
                Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            cursorColor: Color(0xFFE3BD00),
                            controller: phoneNumberController,
                            keyboardType: TextInputType.phone,
                            autofocus: true,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(9)
                            ],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: "Roboto"),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
            child: Text(
                "Please confirm your phone number before moving forward.",
                style: TextStyle(
                    color: Colors.grey, fontSize: 14, fontFamily: "Roboto")),
          )
        ],
      ),
    );
  }
}
