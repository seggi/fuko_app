import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/profile.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/widgets/custom_btn.dart';
import 'package:fuko_app/widgets/other_input.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({Key? key}) : super(key: key);

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final _formKey = GlobalKey();
  String? selectedItem;
  bool isLoading = false;
  late Future<List<ProfileData>>? retrieveProfile;

  late TextEditingController firstNameController = TextEditingController();
  late TextEditingController lastNameController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController usernameController = TextEditingController();

  late final ScaffoldMessengerState? scaffoldMessenger =
      ScaffoldMessenger.of(context);

  Future confirmData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();

    if (firstNameController.text.isEmpty) {
      scaffoldMessenger!.showSnackBar(
          const SnackBar(content: Text("Please Enter your first name")));
    }

    if (lastNameController.text.isEmpty) {
      scaffoldMessenger!.showSnackBar(
          const SnackBar(content: Text("Enter a Valid your last name")));
    }
    if (emailController.text.isEmpty) {
      scaffoldMessenger!
          .showSnackBar(const SnackBar(content: Text("Enter  your email")));
    }
    if (phoneNumberController.text.isEmpty) {
      scaffoldMessenger!.showSnackBar(
          const SnackBar(content: Text("Enter your phone number")));
    }
    if (usernameController.text.isEmpty) {
      scaffoldMessenger!
          .showSnackBar(const SnackBar(content: Text("Enter your username")));
    } else {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> data = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "phone": phoneNumberController.text,
        "email": emailController,
        "username": usernameController,
        "gender": selectedItem
      };

      final response = await http.post(Uri.parse(Network.completeProfile),
          headers: Network.authorizedHeaders(token: token),
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
          PagesGenerator.goTo(context, name: "upload-image");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
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
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveProfile = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Edit profile"),
        )),
        body: FkContentBoxWidgets.body(context, "complete profile",
            widTxt: "complete profile",
            itemList: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FutureBuilder<List<ProfileData>>(
                      future: retrieveProfile,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                firstNameController.text =
                                    snapshot.data[index].firstName;
                                lastNameController.text =
                                    snapshot.data[index].lastName;
                                phoneNumberController.text =
                                    snapshot.data[index].phone;
                                emailController.text =
                                    snapshot.data[index].email;
                                usernameController.text =
                                    snapshot.data[index].username;

                                return Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        commonFormField(
                                            commonController:
                                                firstNameController,
                                            hintTxt: "Your First Name",
                                            inpIcon: Icons.perm_identity),
                                        verticalSpaceMedium,
                                        commonFormField(
                                            commonController:
                                                lastNameController,
                                            hintTxt: "Your Last Name",
                                            inpIcon: Icons.perm_identity),
                                        verticalSpaceMedium,
                                        commonFormField(
                                            commonController:
                                                phoneNumberController,
                                            hintTxt: "Your Phone Number",
                                            inpIcon: Icons.phone),
                                        verticalSpaceMedium,
                                        commonFormField(
                                            commonController: emailController,
                                            hintTxt: "Your Email",
                                            inpIcon: Icons.email_outlined),
                                        verticalSpaceMedium,
                                        commonFormField(
                                            commonController:
                                                usernameController,
                                            hintTxt: "Your Username",
                                            inpIcon: Icons.person_outline),
                                        verticalSpaceMedium,
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  color: fkGreyText,
                                                  width: 1.0)),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedItem,
                                              isExpanded: true,
                                              hint: const Text("Select gender",
                                                  maxLines: 3),
                                              items: [
                                                "Female",
                                                "Male",
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    textAlign: TextAlign.left,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                            ? customTextButton(context,
                                                btnTxt: "Update", fn: () {
                                                confirmData();
                                              })
                                            : const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                ),
                                              ),
                                        verticalSpaceRegular,
                                      ],
                                    ));
                              });
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            snapshot.error != null
                                ? "Failed to load data"
                                : "Data not available...",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: fkGreyText),
                          ));
                        }
                        return Container(
                            padding: const EdgeInsets.all(20.0),
                            margin: const EdgeInsets.only(bottom: 200),
                            child: const Center(
                                child: Text(
                              "Loading info...",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  // fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: fkGreyText),
                            )));
                      }),
                ),
              )
            ]));
  }
}
