import 'package:flutter/material.dart';
import 'package:fuko_app/screens/auth/login.dart';
import 'package:fuko_app/screens/auth/signup.dart';
import 'package:fuko_app/screens/screens/home.dart';
import 'package:fuko_app/widgets/shared/style.dart';

Widget authButtom({context, title, btnColor, textColor, fn}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
    decoration: title == "Login"
        ? BoxDecoration(
            color: btnColor, borderRadius: BorderRadius.circular(8.0))
        : BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: ftBtnColorBgSolid, width: 2.0)),
    child: TextButton(
        child: title == "Login"
            ? Text(
                title,
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0),
              )
            : Text(
                title,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0),
              ),
        onPressed: fn),
  );
}

Widget customButtomB(context, title, btnColor, textColor) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
    decoration: BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.cyan)),
    child: TextButton(
      child: Text(
        title,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w600, fontSize: 20.0),
      ),
      onPressed: () {
        if (title == "Login") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else if (title == "Sign up") {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => SignUpPage()));
        } else if (title == "next") {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      },
    ),
  );
}
