import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/jwt_decode.dart';
import 'package:fuko_app/widgets/input_email.dart';
import 'package:http/http.dart' as http;

import 'package:fuko_app/core/user.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/widgets/custom_btn.dart';
import 'package:fuko_app/widgets/input_pwd.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import 'auth_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FkAuthWidgets fkAuthWidgets = FkAuthWidgets();
  late String isSignedIn;
  // Login controllers
  bool isLoading = false;
  final _formKey = GlobalKey();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    late ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);
    setState(() {
      isLoading = true;
    });

    final String email = emailController.text;
    final String password = passwordController.text;

    if (emailController.text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      scaffoldMessenger
          .showSnackBar(const SnackBar(content: Text("Please Enter email")));
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      scaffoldMessenger
          .showSnackBar(const SnackBar(content: Text("Please Enter Password")));
    } else {
      final response = await http.post(Uri.parse(Network.login),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{'email': email, 'password': password}));

      // Save token in local storage and manage it
      if (response.statusCode == 201) {
        User user = User.fromJson(jsonDecode(response.body));

        UserPreferences.setToken(user.token!);
        UserPreferences.setUserId(user.data!["user_id"].toString());

        fkJwtDecode(tokenKey: user.token);

        if (user.data!['status'] == true) {
          PagesGenerator.directTo(context,
              pathName: "/",
              itemData: {"data": user.data},
              provider: "auth",
              token: user.token);
        } else {
          setState(() {
            isLoading = false;
          });
          PagesGenerator.goTo(context,
              pathName: "/complete-profile",
              itemData: {"data": user.data, "token": user.token},
              provider: "auth");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
            "Wrong password or email",
            style: TextStyle(color: Colors.red),
          ),
        ));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return FkAuthWidgets.body(
      context,
      itemList: <Widget>[
        FkAuthWidgets.topItemsBox(context, itemList: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.language_outlined,
                      color: fkBlueText,
                    ))),
          ),
          fkAuthWidgets.authTopContent(itemList: const [
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
                "Welcome to Fuko App, first of all start by login.\nFor you to get access on what we reserved for you.",
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
          EmailInputFeild(emailController: emailController),
          verticalSpaceRegular,
          PwdInputField(
            passwordController: passwordController,
          ),
          verticalSpaceLarge,
          // isLoading == false
          // ?
          authButton(
              context: context,
              title: 'Login',
              btnColor: ftBtnColorBgSolid,
              textColor: fkWhiteText,
              loading: isLoading,
              fn: () {
                login();
              }),
          // : const SizedBox(
          //     height: 20,
          //     width: 20,
          //     child: CircularProgressIndicator(
          //       strokeWidth: 2.0,
          //     ),
          //   ),
          verticalSpaceRegular,
          authButton(
              context: context,
              title: 'Sign Up',
              btnColor: ftBtnColorBgSolid,
              textColor: fkWhiteText,
              fn: () => PagesGenerator.goTo(context, pathName: "/register"))
        ])
      ],
    );
  }
}
