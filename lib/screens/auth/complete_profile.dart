import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:http/http.dart' as http;

import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/widgets/custom_btn.dart';
import 'package:fuko_app/widgets/other_input.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class CompleteProfile extends StatefulWidget {
  CompleteProfile({
    Key? key,
  }) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  bool isLoading = false;
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();
  final _formKey = GlobalKey();
  // Form Input
  String? selectedItem;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  late final ScaffoldMessengerState? scaffoldMessenger =
      ScaffoldMessenger.of(context);

  Future confirmData(context, userData) async {
    if (firstNameController.text.isEmpty) {
      scaffoldMessenger!
          .showSnackBar(const SnackBar(content: Text("Please Enter Username")));
    }

    if (lastNameController.text.isEmpty) {
      scaffoldMessenger!
          .showSnackBar(const SnackBar(content: Text("Enter a Valid Email")));
    }

    if (phoneNumberController.text.isEmpty) {
      scaffoldMessenger!.showSnackBar(
          const SnackBar(content: Text("Passwords did not match!")));
    } else {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> data = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "phone": phoneNumberController.text,
        "status": true,
        "user_id": userData['data']['user_id'],
        "gender": selectedItem
      };

      final response = await http.post(Uri.parse(Network.completeProfile),
          headers: Network.authorizedHeaders(token: userData["token"]),
          body: jsonEncode(data));

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });

        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['code'] == 'success') {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${jsonResponse['message']}")));
          PagesGenerator.goTo(context,
              pathName: "/home", itemData: userData["data"], provider: "auth");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${jsonResponse['message']}")));
        }
      } else if (response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['code'] == 'success') {
          scaffoldMessenger!.showSnackBar(
              SnackBar(content: Text("${jsonResponse['message']}")));

          PagesGenerator.goTo(context,
              pathName: "/home", itemData: userData["data"], provider: "auth");
        } else {
          setState(() {
            isLoading = false;
          });
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
    final userData = FkManageProviders.get(context)["auth"][0];

    return FkContentBoxWidgets.body(context, "complete profile",
        widTxt: "complete profile",
        itemList: [
          fkContentBoxWidgets.initialItems(itemList: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                userData['data']['username'],
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: fkBlackText),
              ),
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Welocome to FUKO, Please fill these fields bofre you start",
                style: TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w300,
                    fontSize: 14),
              ),
            )
          ]),
          FkContentBoxWidgets.buttonsItemsBox(context, itemList: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    commonFormField(
                        commonController: firstNameController,
                        hintTxt: "Your First Name",
                        inpIcon: Icons.perm_identity),
                    verticalSpaceRegular,
                    commonFormField(
                        commonController: lastNameController,
                        hintTxt: "Your Last Name",
                        inpIcon: Icons.perm_identity),
                    verticalSpaceRegular,
                    commonFormField(
                        commonController: phoneNumberController,
                        hintTxt: "Your Phone Number",
                        inpIcon: Icons.phone),
                    verticalSpaceRegular,
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: fkGreyText, width: 2.0)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedItem,
                          isExpanded: true,
                          hint: const Text("Select gender", maxLines: 3),
                          items: [
                            "Female",
                            "Male",
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedItem = value ?? "";
                            });
                          },
                        ),
                      ),
                    ),
                    verticalSpaceLarge,
                    isLoading == false
                        ? customTextButton(context, btnTxt: "Start", fn: () {
                            confirmData(context, userData);
                          })
                        : const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                    verticalSpaceRegular,
                  ],
                )),
          ])
        ]);
  }
}
