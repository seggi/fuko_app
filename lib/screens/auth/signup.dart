import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

import 'package:fuko_app/screens/auth/auth_widgets.dart';
import 'package:fuko_app/widgets/custom_btn.dart';
import 'package:fuko_app/widgets/input_email.dart';
import 'package:fuko_app/widgets/input_pwd.dart';
import 'package:fuko_app/widgets/other_input.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  FkAuthWidgets fkAuthWidgets = FkAuthWidgets();
  // Declare TextInputForm
  final _formKey = GlobalKey();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reppeatPasswordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  late final ScaffoldMessengerState? scaffoldMessenger =
      ScaffoldMessenger.of(context);
  late RegExp reg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (usernameController.text.isEmpty) {
      scaffoldMessenger!
          .showSnackBar(const SnackBar(content: Text("Please Enter Username")));
      // return;
    }

    if (!reg.hasMatch(emailController.text)) {
      scaffoldMessenger!
          .showSnackBar(const SnackBar(content: Text("Enter a Valid Email")));
      // return;
    }

    if (reppeatPasswordController.text.isEmpty ||
        reppeatPasswordController.text.length < 6) {
      scaffoldMessenger!.showSnackBar(const SnackBar(
          content: Text("Reppeat Password should be min 6 characters")));
      // return;
    }

    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      scaffoldMessenger!.showSnackBar(
          const SnackBar(content: Text("Password should be min 6 characters")));
      // return;
    }
    if (passwordController.text != reppeatPasswordController.text) {
      scaffoldMessenger!.showSnackBar(
          const SnackBar(content: Text("Passwords did not match!")));
      // return;
    } else {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> data = {
        "username": usernameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "birth_date": birthDateController.text,
      };

      final response = await http.post(Uri.parse(Network.register),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });

        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['code'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${jsonResponse['message']}")));
          Navigator.of(context).pushNamed('/');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${jsonResponse['message']}")));
        }
      } else if (response.statusCode == 201) {
        setState(() {
          isLoading = false;
        });

        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['code'] == 'success') {
          scaffoldMessenger!.showSnackBar(
              SnackBar(content: Text("${jsonResponse['message']}")));
          Navigator.of(context).pushNamed('/');
        } else {
          scaffoldMessenger!.showSnackBar(
              SnackBar(content: Text("${jsonResponse['message']}")));
        }
      } else {
        setState(() {
          isLoading = false;
        });
        scaffoldMessenger!
            .showSnackBar(const SnackBar(content: Text("Please Try again")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FkAuthWidgets.body(
      context,
      itemList: [
        FkAuthWidgets.topItemsBox(context, itemList: [
          fkAuthWidgets.authTopContent(itemList: const [
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
                "To get access to our services please register first.",
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
          EmailInputFeild(
            emailController: emailController,
          ),
          verticalSpaceRegular,
          birthDateFormField(birthDateController: birthDateController),
          verticalSpaceRegular,
          PwdInputField(
            passwordController: passwordController,
          ),
          verticalSpaceRegular,
          reppeatFormField(
              reppeatPasswordController: reppeatPasswordController),
          verticalSpaceLarge,
          isLoading == false
              ? authButton(
                  context: context,
                  title: 'Sign Up',
                  btnColor: ftBtnColorBgSolid,
                  textColor: fkWhiteText,
                  fn: () {
                    signUp();
                  })
              : const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
          verticalSpaceRegular,
          authButton(
            context: context,
            title: "Back to login",
            btnColor: ftBtnColorBgSolid,
            textColor: fkWhiteText,
            fn: () => PagesGenerator.goTo(context, pathName: "/login"),
          ),
          verticalSpaceRegular,
        ])
      ],
    );
  }
}
