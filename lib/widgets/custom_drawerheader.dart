import 'package:flutter/material.dart';

class CustomDrawerHeader extends StatelessWidget {
  CustomDrawerHeader({this.profilePic, this.profileName, this.phoneNumber});

  final String profilePic;
  final String profileName;
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    String defaultIcon = "assets/icons/testprofile.jpg";
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            maxRadius: 32.5,
            minRadius: 20,
            backgroundColor: Colors.white,
            foregroundImage:
                AssetImage(profilePic == null ? defaultIcon : profilePic),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileName,
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(phoneNumber,
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5)))
              ])
        ],
      ),
    );
  }
}
