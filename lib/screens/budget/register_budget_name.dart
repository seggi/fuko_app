import 'dart:async';
import 'dart:convert';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class RegisterBudgetName extends StatefulWidget {
  const RegisterBudgetName({Key? key}) : super(key: key);

  @override
  State<RegisterBudgetName> createState() => _RegisterBudgetNameState();
}

class _RegisterBudgetNameState extends State<RegisterBudgetName> {
  final _formKey = GlobalKey();
  bool loading = false;
  TextEditingController addBudgetNameController = TextEditingController();

  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  Future saveBudgetName() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();
    Map newItem = {
      "name": addBudgetNameController.text,
    };

    if (addBudgetNameController.text == "") {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "This field can't remain empty.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));
      return;
    } else {
      setState(() {
        loading = true;
      });
      final response = await http.post(Uri.parse(Network.registerBudgetName),
          headers: Network.authorizedHeaders(token: token),
          body: jsonEncode(newItem));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["code"] == "Alert") {
          setState(() {
            loading = false;
          });
          scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(
              "${data["message"]}",
              style: const TextStyle(color: Colors.red),
            ),
          ));
        } else {
          PagesGenerator.goTo(context, pathName: "/budget?status=true");
        }
      } else {
        setState(() {
          loading = false;
        });
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
                          PagesGenerator.goTo(context, pathName: "/budget")),
                ],
              ),
            ),
            verticalSpaceLarge,
            Container(
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Add title",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: addBudgetNameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: 'Enter budget title',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: fkInputFormBorderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0))),
                      onSaved: (String? value) {},
                    ),
                    verticalSpaceMedium,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: fkDefaultColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            width: 2.0,
                            color: fkDefaultColor,
                          )),
                      child: TextButton(
                        onPressed:
                            loading == true ? () {} : () => saveBudgetName(),
                        child: loading == false
                            ? const Icon(
                                Icons.add_circle,
                                color: fkWhiteText,
                              )
                            : const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  backgroundColor: fkWhiteText,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]))
    ]);
  }
}
