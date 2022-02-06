import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/navigation.dart';
import 'package:fuko_app/screens/auth/signup.dart';
import 'package:fuko_app/widgets/custom_btn.dart';
import 'package:fuko_app/widgets/input_pwd.dart';
import 'package:fuko_app/widgets/other_input.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:provider/provider.dart';

import 'auth_widgets.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FkAuthWidgets fkAuthWidgets = new FkAuthWidgets();
  // Login controllers
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    NavigationController navigation =
        Provider.of<NavigationController>(context, listen: false);
    return FkAuthWidgets.body(
      context,
      itemList: [
        FkAuthWidgets.topItemsBox(context, itemList: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.language_outlined,
                      color: Colors.deepOrangeAccent,
                    ))),
          ),
          fkAuthWidgets.authTopContent(itemList: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Login",
                style: TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Welcom to Fuko App, first of all start by login.\nFor you to get access on what we reserved for you.",
                style: TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w300,
                    fontSize: 14),
              ),
            )
          ])
        ]),
        // Bottom Widgets
        FkAuthWidgets.authInputFieldBox(context, formKey: _formKey, itemList: [
          usernameFormField(usernameController: usernameController),
          verticalSpaceRegular,
          PwdInputField(
            passwordController: passwordController,
          ),
          verticalSpaceLarge,
          authButtom(
            context: context,
            title: 'Login',
            btnColor: ftBtnColorBgSolid,
            textColor: fkWhiteText,
            fn: () {
              navigation.changeScreen('/home');
            },
          ),
          verticalSpaceRegular,
          authButtom(
              context: context,
              title: 'Sign Up',
              btnColor: ftBtnColorBgSolid,
              textColor: fkWhiteText,
              fn: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              }),
        ])
      ],
    );
  }
}
