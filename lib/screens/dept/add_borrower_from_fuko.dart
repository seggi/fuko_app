import 'dart:async';
import 'dart:convert';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/core/user.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class AddBorrowerFromFuko extends StatefulWidget {
  const AddBorrowerFromFuko({Key? key}) : super(key: key);

  @override
  State<AddBorrowerFromFuko> createState() => _AddBorrowerFromFukoState();
}

class _AddBorrowerFromFukoState extends State<AddBorrowerFromFuko> {
  final _formKey = GlobalKey();
  TextEditingController addBorrowerNameController = TextEditingController();
  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
  bool showFoundUser = false;

  Future saveBorrowerName({userId}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();
    print("$userId >>>>>");
    Map newItem = {
      "borrower_id": userId.toString(),
    };

    if (addBorrowerNameController.text == "") {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "This field can't remain empty.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));
      return;
    } else {
      final response = await http.post(Uri.parse(Network.addNewBorrower),
          headers: Network.authorizedHeaders(token: token),
          body: jsonEncode(newItem));

      if (response.statusCode == 200) {
        PagesGenerator.goTo(context, pathName: "/dept?status=true");
      } else {
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
            "Error from server",
            style: TextStyle(color: Colors.red),
          ),
        ));
      }
    }
  }

  Future searchUser() async {
    var token = await UserPreferences.getToken();
    Map newItem = {
      "username": addBorrowerNameController.text,
    };
    if (addBorrowerNameController.text == "") {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "This field can't remain empty.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));
      return;
    } else {
      final response = await http.post(
          Uri.parse(Network.searchBorrowerFromUsers),
          headers: Network.authorizedHeaders(token: token),
          body: jsonEncode(newItem));

      if (response.statusCode == 200) {
        setState(() {
          showFoundUser = true;
          NewBorrower newBorrowerData =
              NewBorrower.fromJson(jsonDecode(response.body));
          FkManageProviders.save["save_new_borrower"](context,
              itemData: {"data": newBorrowerData.userData});
        });
      } else {
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
            "Error from server",
            style: TextStyle(color: Colors.red),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final borrowerList = FkManageProviders.get(context)["get-borrowers"];

    return FkScrollViewWidgets.body(context, itemList: [
      Container(
          padding: const EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () =>
                          PagesGenerator.goTo(context, pathName: "/dept")),
                ],
              ),
            ),
            verticalSpaceLarge,
            Container(
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Add borrower from fuko",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            autofocus: true,
                            controller: addBorrowerNameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10),
                                hintText: 'Enter Borrower Name',
                                border: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: fkInputFormBorderColor,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0))),
                            onSaved: (String? value) {},
                          ),
                        ),
                        InkWell(
                          onTap: () => searchUser(),
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(Icons.search_sharp)),
                        )
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: showFoundUser != true
                        ? const SizedBox()
                        : ListView.builder(
                            itemCount: borrowerList[0]["data"].length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.account_circle_outlined),
                                  title: Text(
                                      "${borrowerList[index]["username"]}"),
                                  subtitle: Text(
                                      "${borrowerList[index]["last_name"]} ${borrowerList[index]["first_name"]}"),
                                  trailing: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: fkDefaultColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 2.0,
                                            color: fkDefaultColor,
                                          )),
                                      child: InkWell(
                                        onTap: () => saveBorrowerName(
                                            userId: borrowerList[index]["id"]),
                                        child: const Icon(
                                          Icons.add,
                                          color: fkGreyText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                  ),
                ],
              ),
            )
          ]))
    ]);
  }
}
