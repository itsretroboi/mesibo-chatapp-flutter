import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    this.icon,
    this.title,
    this.details,
  });

  final Widget icon;
  final String title;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 300.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              icon == null
                  ? Material()
                  : Align(
                      child: icon,
                      alignment: Alignment.center,
                    ),
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 150.0,
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Color(0xFF333808),
                        fontSize: 22.0,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                details,
                style: TextStyle(
                    color: Colors.black, fontFamily: "Roboto", fontSize: 15.0),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
