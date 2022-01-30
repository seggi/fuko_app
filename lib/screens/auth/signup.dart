import 'package:flutter/material.dart';
import 'package:fuko_app/screens/auth/auth_widgets.dart';
import 'package:fuko_app/screens/auth/login.dart';
import 'package:fuko_app/widgets/custom_btn.dart';
import 'package:fuko_app/widgets/input_email.dart';
import 'package:fuko_app/widgets/input_pwd.dart';
import 'package:fuko_app/widgets/other_input.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FkAuthWidgets fkAuthWidgets = new FkAuthWidgets();
  @override
  Widget build(BuildContext context) {
    return FkAuthWidgets.body(
      context,
      itemList: [
        FkAuthWidgets.topItemsBox(context, itemList: [
          fkAuthWidgets.authTopContent(itemList: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Register",
                style: TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "To get access to our sevices please register first.",
                style: TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w300,
                    fontSize: 14),
              ),
            )
          ])
        ]),
        // Bottom Widgets
        FkAuthWidgets.authInputFieldBox(context, itemList: [
          usernameFormField(),
          verticalSpaceRegular,
          EmailInputFeild(),
          verticalSpaceRegular,
          PwdInputField(),
          verticalSpaceRegular,
          reppeatFormField(),
          verticalSpaceLarge,
          authButtom(
              context: context,
              title: 'Sign Up',
              btnColor: ftBtnColorBgSolid,
              textColor: fkWhiteText,
              fn: () {}),
          verticalSpaceRegular,
          authButtom(
              context: context,
              title: 'Login',
              btnColor: ftBtnColorBgSolid,
              textColor: fkWhiteText,
              fn: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }),
          verticalSpaceRegular,
        ])
      ],
    );
  }
}
